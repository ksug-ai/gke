FROM python:3.11-slim
WORKDIR /app
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir flask
COPY app.py .
EXPOSE 5000
CMD ["python3", "app.py"]
