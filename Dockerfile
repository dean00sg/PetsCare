FROM alpine:3.17

WORKDIR /src


COPY ./requirements.txt /src/requirements.txt

RUN apk add python3
RUN apk add py3-pip
RUN pip install -r /src/requirements.txt --ignore-installed packaging

#CMD ["pytest", "--junitxml=result.xml"]
CMD ["py.test", "--cov-report xml:coverage.xml", "--cov=.", "--junitxml=result.xml"]
COPY . /src 

RUN ls

# CMD [ "cd", "backend" ]
RUN cd /backend
CMD ["python", "-m", "uvicorn", "main:app", "--reload"]

EXPOSE 8000:8000