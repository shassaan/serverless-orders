FROM public.ecr.aws/lambda/python:3.8

ARG SERVICE_NAME


COPY requirements.txt  .

RUN pip3 install -r requirements.txt --target "${LAMBDA_TASK_ROOT}"


ADD services/${SERVICE_NAME}/ ${LAMBDA_TASK_ROOT}/services/${SERVICE_NAME}/
ADD src/ {LAMBDA_TASK_ROOT}/src/
ADD main.py ${LAMBDA_TASK_ROOT}



ENV SERVICE=${SERVICE_NAME}

CMD [ "main.handler" ]
