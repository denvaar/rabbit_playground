import Config

config :amqp,
  connections: [
    events_conn: [
      url: "amqp://guest:guest@localhost:5672"
    ]
  ],
  channels: [
    events_channel: [connection: :events_conn]
  ]
