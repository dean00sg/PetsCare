FROM alpine:3.17

# Set the working directory to /src
WORKDIR /src

# Copy the requirements.txt file
COPY ./requirements.txt /src/requirements.txt

# Install Python and pip
RUN apk add --no-cache python3 py3-pip

# Install dependencies from requirements.txt
RUN pip install -r /src/requirements.txt --ignore-installed packaging

# Copy the rest of the application
COPY . /src

# Set the working directory to /src/backend
WORKDIR /src/backend

# Run the application using Uvicorn
CMD ["python", "-m", "uvicorn", "main:app", "--reload"]

# Expose the port
EXPOSE 8000:8000
