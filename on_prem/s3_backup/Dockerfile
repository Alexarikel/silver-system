FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir /app && apt-get update && apt-get install -y \
        mariadb-client \
        python3 \
        python3-pip \
        tzdata \
        && rm -rf /var/lib/apt/lists/*

RUN pip3 install boto3

WORKDIR /app

COPY ./forimage/ ./

RUN chmod +x dump.sh

ENTRYPOINT ["./dump.sh"]
CMD ["python3 db_script.py"]
