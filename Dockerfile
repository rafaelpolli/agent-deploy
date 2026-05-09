# Bedrock AgentCore Runtime container.
# Build: docker build -t <agent> .
# Push:  docker tag <agent>:latest <ecr-uri>:latest && docker push <ecr-uri>:latest
# AgentCore Runtime invokes the container's HTTP server on port 8080.
FROM python:3.12-slim

WORKDIR /app

RUN pip install --no-cache-dir uv

COPY pyproject.toml .
RUN uv pip install --system --no-cache .

COPY . .

ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED=1

EXPOSE 8080

# AgentCore Runtime entrypoint — BedrockAgentCoreApp.run() listens on 0.0.0.0:8080
CMD ["python", "-m", "agent.runner"]
