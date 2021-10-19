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

---

## JS Plugin Development

## Download JS PDK and test

```
git clone https://github.com/Kong/kong-js-pdk

cd kong-js-pdk

npm install

npm install babel-preset-env --save

npm test
```

## Develop and test custom plugin

```
cp ../{js-censor.js,js-censor.test.js} examples

cp ../plugin_test.js .

npm install --save text-censor

npm test
```

## Install dependencies and create custom Kong image

```
docker exec -it -u root kong /bin/bash

apk add --update nodejs npm python make g++

npm install --unsafe -g kong-pdk@0.3.0

cd /usr/local/kong

mkdir js-plugins

cd js-plugins

npm install text-censor

exit
```

## Copy custom plugin to Kong instance

```
docker cp examples/js-hello.js kong:/usr/local/kong/js-plugins

docker cp examples/js-censor.js kong:/usr/local/kong/js-plugins

docker commit kong kong-ent-js
```

## Run Kong using custom image and enable JS plugin environment variables

```
cd start-kong

docker-compose down

cd ../start-jsplugin

docker-compose run kong kong migrations bootstrap

docker-compose up -d
```

## Create service and route in Kong

```
http post localhost:8001/services name=strapi-jscp url=http://httpbin.org/anything

http post localhost:8001/services/strapi-jscp/routes paths:='["/custom-jsplugin"]'

http post localhost:8000/custom-jsplugin data='{"content": "hello sexy baby"}'
```

## Apply and test custom plugin

```
http post localhost:8001/services/strapi-jscp/plugins name=js-censor

http post localhost:8000/custom-jsplugin data='{"content": "hello sexy baby"}'
```

## Clean up JS environment

```
cd start-jsplugin

docker-compose down
```

---

## Python Plugin Development

## Download Python PDK

```
git clone https://github.com/Kong/kong-python-pdk
```

## Run Kong

```
cd start-kong

docker-compose run kong kong migrations bootstrap

docker-compose up -d
```

## Install dependencies and create custom Kong image

```
docker exec -it -u root kong /bin/bash

apk add --update python3-dev py3-pip make g++ musl-dev jpeg-dev zlib-dev libffi-dev cairo-dev pango-dev gdk-pixbuf-dev

pip3 install kong-pdk

pip3 install azure-ai-textanalytics==5.2.0b1

cd /usr/local/kong

mkdir python-plugins

exit
```

## Copy custom plugin to Kong instance

```
docker cp py-pii.py kong:/usr/local/kong/python-plugins

docker commit kong kong-ent-py
```


## Run Kong using custom image and enable Python plugin environment variables

```
cd start-kong

docker-compose down

cd ../start-pyplugin

docker-compose run kong kong migrations bootstrap

docker-compose up -d
```

## Create service and route in Kong

```
http post localhost:8001/services name=strapi-pycp url=http://httpbin.org/anything

http post localhost:8001/services/strapi-pycp/routes paths:='["/custom-pyplugin"]'

http post localhost:8000/custom-pyplugin data='{"content": "Microsoft employee with ssn 859-98-0987 is using our awesome API."}'
```

## Apply and test custom plugin

```
http post localhost:8001/services/strapi-pycp/plugins name=py-pii

http post localhost:8000/custom-pyplugin data='{"content": "Microsoft employee with ssn 859-98-0987 is using our awesome API."}'
```

