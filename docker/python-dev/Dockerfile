FROM python:3.8-alpine

RUN apk add --no-cache --virtual .build-deps gcc musl-dev python3-dev 
RUN apk add --no-cache bash make

COPY requirements.txt /tmp/
RUN pip install -r /tmp/requirements.txt

RUN apk del --no-cache .build-deps

RUN mkdir -p /src
COPY src/ /src/
RUN pip install -e /src
COPY Makefile /
COPY tests/ /tests/

WORKDIR /
