FROM python:3.8-alpine

RUN apk add --no-cache --virtual .build-deps gcc musl-dev python3-dev 
RUN apk add --no-cache bash make

COPY requirements.txt /tmp/
RUN pip install -r /tmp/requirements.txt

RUN apk del --no-cache .build-deps

RUN mkdir -p /workspace/src
COPY src/ /workspace//src/
RUN pip install -e /workspace/src
COPY Makefile /workspace/
COPY tests/ /workspace/tests/

WORKDIR /workspace/
