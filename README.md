# Playground

```
# Create "cmw_dev" queue, bind the queue to the exchange via given topics

DynamicSupervisor.start_child(Playground.EventQueueSupervisor, {Playground.EventConsumer, [queue: "cmw_dev", topics: ["cmw_dev.*"]]})


# send a message and see it get routed to the "cmw_dev" queue.
{:ok, channel} = AMQP.Application.get_channel(:events_channel)
AMQP.Basic.publish(channel, "playground.events.x", "cmw_denver.whatever", "hi")

# send a message to queue that doesn't exist yet, "other".
AMQP.Basic.publish(channel, "playground.events.x", "other.whatever", "hi")

# create the queue and bindings
DynamicSupervisor.start_child(Playground.EventQueueSupervisor, {Playground.EventConsumer, [queue: "other", topics: ["other.*"]]})

# send message again, this time it exists
AMQP.Basic.publish(channel, "playground.events.x", "other.whatever", "hi")
```
