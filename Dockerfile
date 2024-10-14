FROM tiangolo/uvicorn-gunicorn-fastapi:python3.8

# Set the working directory to /src
WORKDIR /src

# Copy the requirements.txt file
COPY ./requirements.txt /src/requirements.txt

# Install dependencies
RUN pip install -r /src/requirements.txt --ignore-installed packaging


# Run the application
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]

# Expose the port
EXPOSE 8080
