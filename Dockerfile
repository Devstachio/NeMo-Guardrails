# Use Python 3.11 slim image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy source code first
COPY nemoguardrails/ ./nemoguardrails/
COPY pyproject.toml LICENSE.md README.md ./

# Install the package in development mode
RUN pip install --no-cache-dir -e .

# Expose default ports
EXPOSE 8000 8001

# Default command - you can override this when running
CMD ["nemoguardrails", "--help"]
