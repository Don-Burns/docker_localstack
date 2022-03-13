from kafka import KafkaProducer
# from dotenv import load_dotenv


class config:
    def __init__(self) -> None:
        self.bootstrap = 'localhost:19092,localhost:29092,localhost:39092'
        self.client_id = "spark_testing"   
        self.topic = "local_test"
        self.username = "username"
        self.password = "password"


conf = config()

broker = conf.bootstrap

producer = KafkaProducer(
    bootstrap_servers=conf.bootstrap,
    client_id=conf.client_id
    # sasl_plain_username=params["username"],
    # sasl_plain_password=params["password"],
    # security_protocol="SASL_SSL",
    # sasl_mechanism="SCRAM-SHA-512"
    )

for _ in range(10):
    producer.send(topic=conf.topic, 
        key=b'test', 
        value=b'test message'
        )
    print(_)

producer.flush()