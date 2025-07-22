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

## Installation

```bash
pip install -e .
```

## Quick Start

```bash
# Start interactive chat
nemoguardrails chat --config=path/to/your/config

# Start guardrails server
nemoguardrails server --config=path/to/your/configs

# Get help
nemoguardrails --help
```

## License

Apache License 2.0 - See LICENSE.md

## Original Repository

This is derived from NVIDIA's NeMo-Guardrails: https://github.com/NVIDIA/NeMo-Guardrails
