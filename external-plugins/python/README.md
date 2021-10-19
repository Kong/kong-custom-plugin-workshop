## Python Plugin Development

Prerequities:
1. Started standard Kong instance in external-plugins folder
2. Azure Cognitive Service Subscription Key

## Download Python PDK

```
git clone https://github.com/Kong/kong-python-pdk
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
cd ../start-kong

docker-compose down

cd ../python/start-pyplugin

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

## Clean up Python environment

```
cd start-pyplugin

docker-compose down
```
