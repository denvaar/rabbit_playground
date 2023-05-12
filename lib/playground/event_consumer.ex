defmodule Playground.EventConsumer do
  use Broadway

  def start_link(opts) do
    queue = Keyword.get(opts, :queue)
    topics = Keyword.get(opts, :topics)

    bindings =
      Enum.map(topics, fn topic ->
        {
          "playground.events.x",
          [
            routing_key: topic
          ]
        }
      end)

    Broadway.start_link(__MODULE__,
      name: {:via, Registry, {:queue_registry, queue}},
      producer: [
        module: {
          BroadwayRabbitMQ.Producer,
          connection: "amqp://guest:guest@localhost:5672",
          bindings: bindings,
          queue: queue,
          metadata: [
            :headers,
            :exchange,
            :routing_key,
            :correlation_id
          ],
          declare: [durable: true],
          on_failure: :reject,
          after_connect: &declare_amqp_topology/1,
          qos: [prefetch_count: 1]
        },
        concurrency: 1
      ],
      processors: [
        default: [
          concurrency: 1,
          min_demand: 0,
          max_demand: 1
        ]
      ]
    )
  end

  defp declare_amqp_topology(amqp_channel) do
    AMQP.Exchange.declare(
      amqp_channel,
      "playground.events.x",
      :topic,
      durable: true
    )
  end

  @impl Broadway
  def handle_message(_processor, %Broadway.Message{} = message, _context) do
    IO.inspect(message, label: "handle message")

    message
  end

  @impl Broadway
  def process_name({:via, Registry, {registry, queue_name}}, base_name) do
    {:via, Registry, {registry, {queue_name, base_name}}}
  end
end
