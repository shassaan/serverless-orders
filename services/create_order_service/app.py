import json
from src.connectors.kafka import KafkaProducer
import yaml
import datetime

def run(event, context):
  with open("services/create_order_service/config.yaml") as f:
        config = yaml.safe_load(f)
  
  status_code = None
  message = None

  try:
      http_method = event['requestContext']['http']['method']

      if http_method == 'POST':
          request_body = json.loads(event['body'])

          kakfa = KafkaProducer(hosts=config['kafka']['endpoint'])
          kakfa.enqueue(topic=config['kafka']['topic'],key=request_body["id"],timestamp=int(datetime.datetime.now().timestamp()),value=json.dumps(request_body))
          kakfa.publish()
          status_code = 200
          message = f"Your POST request was successfull with body {request_body}"
  except Exception as e:
      print(e)
      status_code = 500
      message = "Sorry mate, some exception occured!!"
      raise

  return {
      "status_code": status_code,
      "message": message
  }
