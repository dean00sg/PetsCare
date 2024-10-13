FROM alpine:3.17

WORKDIR /src

COPY ./requirements.txt /src/requirements.txt

RUN apk add python3
RUN apk add py3-pip
RUN pip install -r /src/requirements.txt --ignore-installed packaging

#CMD ["pytest", "--junitxml=result.xml"]
CMD ["py.test", "--cov-report xml:coverage.xml", "--cov=.", "--junitxml=result.xml"]
COPY . /src 

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

EXPOSE 8000:8000