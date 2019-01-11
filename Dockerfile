
FROM ubuntu:18.04

MAINTAINER PaloIT

LABEL description="Belcorp's Campaign Manager Back End image for Jenkins"

ENV AWSCLI_VERSION "1.16.60"

VOLUME /project
WORKDIR /project

RUN apt update && \
    apt -y install awscli && \
    apt -y install python-pip git zip curl && \
    pip install pipenv

COPY . .

CMD [ "sh" ]
