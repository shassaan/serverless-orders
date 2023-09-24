import socket

from confluent_kafka import Producer


DEFAULT_PROFILE = 'profile.yaml'

class KafkaProducer:
    def __init__(self, hosts = None) -> None:
        conf = {'bootstrap.servers': hosts,
        'client.id': socket.gethostname(),
        'security.protocol':'SSL'}

        self.producer = Producer(conf)
    
    def publish(self):
        self.producer.flush()

    def delivery_report(self, err, msg):
        if err is not None:
            # Handle failed message
            print(f"Delivery failed for message {msg}: {err}")
        else:
            print(f"Message delivered to {msg.topic()} [{msg.partition()}] at offset {msg.offset()}")    
    
    def enqueue(self, topic, value, key=None, timestamp=None):
        if key and timestamp:
            self.producer.produce(topic, key = key, value = value, timestamp = timestamp, on_delivery=self.delivery_report)
        elif key:
            self.producer.produce(topic, key = key, value = value, on_delivery=self.delivery_report)
        else:
            self.producer.produce(topic, value=value, on_delivery=self.delivery_report)