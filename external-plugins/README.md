## Introduction

The following example will go through the external plugin development and testing:
1. JavaScript - Text censorship custom plugin using external npm module
2. Python - PII detection custom plugin using Azure Cognitive Service Python Library

## Run Kong

```
cd start-kong

docker-compose run kong kong migrations bootstrap

docker-compose up -d
```

## Custom Plugin Development

1. Python: Go to ./python
2. JavaScript: Go to ./javascript