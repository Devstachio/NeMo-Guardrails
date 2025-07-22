# NeMo Guardrails - Personal Project Version

This is a cleaned-up version of NVIDIA's NeMo Guardrails toolkit for personal use. 

## What's Included

- **Core Package** (`nemoguardrails/`): The essential guardrails functionality
- **CLI Tools**: Command-line interface for running guardrails
- **Library**: Built-in guardrails for common use cases
- **Server**: Web server for hosting guardrails
- **Actions Server**: Optional standalone server for running actions securely

## What Was Removed

- All test files and QA infrastructure
- Documentation (available online at https://docs.nvidia.com/nemo/guardrails)
- Examples (available in the original repository)
- Development tools and configuration files
- Build scripts and CI/CD configurations

## Installation & Usage

This repository has been cleaned up to focus only on core NeMo Guardrails functionality for personal use. You can run NeMo Guardrails either locally with Python or using Docker.

### Option 1: Local Python Installation (Recommended)

#### Prerequisites
- Python 3.11 or 3.13 (recommended)
- pip (Python package installer)

#### Installation Steps

1. **Clone and navigate to the repository:**
   ```bash
   cd /path/to/NeMo-Guardrails-ed
   ```

2. **Create a virtual environment:**
   ```bash
   python3 -m venv .venv
   source .venv/bin/activate  # On Windows: .venv\Scripts\activate
   ```

3. **Install the package in development mode:**
   ```bash
   pip install -e .
   ```

#### Local Usage

**Start Interactive Chat:**
```bash
nemoguardrails chat --config ./configs/simple-example
```

**Start Server:**
```bash
nemoguardrails server --config ./configs/simple-example
```
The server will be available at `http://localhost:8000`

**View Available Commands:**
```bash
nemoguardrails --help
```

### Option 2: Docker Installation

#### Build the Image

```bash
# Build the Docker image
docker build -t nemo-guardrails .
```

#### Run with Docker

```bash
# Run interactive chat (mount your config directory)
docker run -it --rm \
  -v $(pwd)/configs:/app/configs \
  nemo-guardrails \
  nemoguardrails chat --config=/app/configs/your-config

# Run guardrails server
docker run -d \
  -p 8000:8000 \
  -v $(pwd)/configs:/app/configs \
  --name guardrails-server \
  nemo-guardrails \
  nemoguardrails server --config=/app/configs --port=8000

# Run actions server
docker run -d \
  -p 8001:8001 \
  --name actions-server \
  nemo-guardrails \
  nemoguardrails actions-server --port=8001
```

#### Run with Docker Compose

```bash
# Start guardrails server
docker-compose up

# Start both guardrails and actions server
docker-compose --profile actions up

# Run in background
docker-compose up -d
```

#### Easy Docker Script

Use the provided `docker-run.sh` script for simplified Docker operations:

```bash
# Build image
./docker-run.sh build

# Start interactive chat
export OPENAI_API_KEY="your-api-key"
./docker-run.sh chat

# Start guardrails server
./docker-run.sh server

# Start actions server
./docker-run.sh actions-server

# Start with docker-compose
./docker-run.sh compose

# Stop all containers
./docker-run.sh stop

# Clean up everything
./docker-run.sh clean
```

#### Access the Services

- **Guardrails Server**: http://localhost:8000
- **Actions Server**: http://localhost:8001
- **API Documentation**: http://localhost:8000/docs

#### Setup Config Directory

Create a `configs` directory structure:
```
configs/
├── my-config/
│   ├── config.yml
│   ├── flows.co
│   └── actions.py
```

## Summary

✅ **Both Docker and Local Python installations are now fully functional**

### Key Differences:

**Local Python Installation:**
- Faster startup and development
- Direct access to Python environment  
- Easier debugging and customization
- Uses your system's Python and dependencies

**Docker Installation:**
- Isolated environment
- Consistent across different systems
- Includes helper scripts for easier management
- Better for production deployments

### Quick Test

Run the included test script to verify your local installation:
```bash
# Activate virtual environment (if using local install)
source .venv/bin/activate

# Run test
python test_local.py
```

### Configuration

Both installation methods use the same configuration format. Place your configuration files in the `configs/` directory. The `simple-example` config is included for testing.

## License

Apache License 2.0 - See LICENSE.md

## Original Repository

This is derived from NVIDIA's NeMo-Guardrails: https://github.com/NVIDIA/NeMo-Guardrails
