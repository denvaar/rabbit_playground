# Playground

```elixir
DynamicSupervisor.start_child(Playground.EventQueueSupervisor, {Playground.EventConsumer, [subscriber: "cmw_dev", organization_id: 1, integration_name: "yardi"]})

# send a message and see it get routed to the appropriate queue

{:ok, channel} = AMQP.Application.get_channel(:events_channel)

AMQP.Basic.publish(channel, "playground.events.x", "", "message!", headers: [{"subscriber", "cmw_dev"}, {"organization_id", 1}, {"integration_name", "yardi"}])
```
