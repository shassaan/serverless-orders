import json


def run(event, context):
  status_code = None
  message = None

  try:
      http_method = event['requestContext']['http']['method']

      if http_method == 'POST':
          request_body = json.loads(event['body'])
          print(request_body)
          status_code = 200
          message = f"Your POST request was successfull with body {request_body}"
  except Exception as e:
      status_code = 500
      message = "Sorry mate, some exception occured!!"

  finally:
      return {
          "status_code": status_code,
          "message": message
      }
