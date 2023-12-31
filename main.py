import os
import importlib
def handler(event, context):
    try:
        service_name = os.getenv('SERVICE',None)
        app = importlib.import_module(f'services.{service_name}.app')
        app.run(event,context)
        if service_name is None:
            raise Exception("no service name specified!")
    except Exception as ex:
        print(f"critical exception occured {ex}")
        raise