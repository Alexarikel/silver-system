FROM ubuntu:latest

RUN mkdir /app && apt-get update && apt-get install -y \
	libmariadb-dev \
	python3 \
	python3-pip \
	&& rm -rf /var/lib/apt/lists/*	

WORKDIR /app

COPY ./requirements.txt . 

RUN pip3 install --no-cache-dir --upgrade -r ./requirements.txt

COPY ./forimage/ ./

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"] 

