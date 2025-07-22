#!/bin/bash

# NeMo Guardrails Docker Helper Script

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IMAGE_NAME="nemo-guardrails"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_usage() {
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  build           Build the Docker image"
    echo "  chat            Start interactive chat"
    echo "  server          Start guardrails server"
    echo "  actions-server  Start actions server"
    echo "  compose         Start with docker-compose"
    echo "  stop            Stop running containers"
    echo "  clean           Remove containers and images"
    echo ""
    echo "Options:"
    echo "  --config-dir DIR    Config directory (default: ./configs)"
    echo "  --port PORT         Port for server (default: 8000)"
    echo "  --help             Show this help"
}

build_image() {
    echo -e "${GREEN}Building NeMo Guardrails Docker image...${NC}"
    docker build -t "$IMAGE_NAME" "$SCRIPT_DIR"
}

start_chat() {
    local config_dir="${1:-$SCRIPT_DIR/configs}"
    
    if [[ ! -d "$config_dir" ]]; then
        echo -e "${RED}Config directory not found: $config_dir${NC}"
        echo -e "${YELLOW}Creating example config...${NC}"
        mkdir -p "$config_dir"
    fi
    
    echo -e "${GREEN}Starting interactive chat...${NC}"
    docker run -it --rm \
        -v "$config_dir:/app/configs" \
        -e OPENAI_API_KEY="${OPENAI_API_KEY}" \
        "$IMAGE_NAME" \
        nemoguardrails chat --config=/app/configs/simple-example
}

start_server() {
    local config_dir="${1:-$SCRIPT_DIR/configs}"
    local port="${2:-8000}"
    
    echo -e "${GREEN}Starting guardrails server on port $port...${NC}"
    docker run -d \
        -p "$port:$port" \
        -v "$config_dir:/app/configs" \
        -e OPENAI_API_KEY="${OPENAI_API_KEY}" \
        --name guardrails-server \
        "$IMAGE_NAME" \
        nemoguardrails server --config=/app/configs --port="$port"
    
    echo -e "${GREEN}Server started! Access at http://localhost:$port${NC}"
    echo -e "${YELLOW}API docs available at http://localhost:$port/docs${NC}"
}

start_actions_server() {
    local port="${1:-8001}"
    
    echo -e "${GREEN}Starting actions server on port $port...${NC}"
    docker run -d \
        -p "$port:$port" \
        --name actions-server \
        "$IMAGE_NAME" \
        nemoguardrails actions-server --port="$port"
    
    echo -e "${GREEN}Actions server started! Access at http://localhost:$port${NC}"
}

start_compose() {
    echo -e "${GREEN}Starting with docker-compose...${NC}"
    docker-compose up -d
    echo -e "${GREEN}Services started!${NC}"
    echo -e "${YELLOW}Guardrails: http://localhost:8000${NC}"
    echo -e "${YELLOW}Actions: http://localhost:8001${NC}"
}

stop_containers() {
    echo -e "${GREEN}Stopping containers...${NC}"
    docker stop guardrails-server actions-server 2>/dev/null || true
    docker-compose down 2>/dev/null || true
}

clean_up() {
    echo -e "${GREEN}Cleaning up containers and images...${NC}"
    stop_containers
    docker rm guardrails-server actions-server 2>/dev/null || true
    docker rmi "$IMAGE_NAME" 2>/dev/null || true
}

# Parse arguments
CONFIG_DIR="$SCRIPT_DIR/configs"
PORT="8000"

while [[ $# -gt 0 ]]; do
    case $1 in
        --config-dir)
            CONFIG_DIR="$2"
            shift 2
            ;;
        --port)
            PORT="$2"
            shift 2
            ;;
        --help)
            print_usage
            exit 0
            ;;
        build)
            COMMAND="build"
            shift
            ;;
        chat)
            COMMAND="chat"
            shift
            ;;
        server)
            COMMAND="server"
            shift
            ;;
        actions-server)
            COMMAND="actions-server"
            shift
            ;;
        compose)
            COMMAND="compose"
            shift
            ;;
        stop)
            COMMAND="stop"
            shift
            ;;
        clean)
            COMMAND="clean"
            shift
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            print_usage
            exit 1
            ;;
    esac
done

# Execute command
case "${COMMAND:-}" in
    build)
        build_image
        ;;
    chat)
        build_image
        start_chat "$CONFIG_DIR"
        ;;
    server)
        build_image
        start_server "$CONFIG_DIR" "$PORT"
        ;;
    actions-server)
        build_image
        start_actions_server "$PORT"
        ;;
    compose)
        start_compose
        ;;
    stop)
        stop_containers
        ;;
    clean)
        clean_up
        ;;
    *)
        echo -e "${RED}No command specified${NC}"
        print_usage
        exit 1
        ;;
esac
