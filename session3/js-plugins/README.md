## Run Kong

```
docker-compose run kong kong migrations bootstrap

docker-compose up -d
```

## Create sample API

email: admin@demo.com

password: P@ssw0rd1

```
curl https://warrenkongdemostor.blob.core.windows.net/strapiappdata/app.zip --output app.zip

unzip -o app.zip

docker-compose -f docker-compose-strapi.yaml up -d

docker logs strapi-compose_strapi_1 --follow
```

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
docker exec -it -u root kong-ent /bin/bash

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
docker cp examples/js-hello.js kong-ent:/usr/local/kong/js-plugins

docker cp examples/js-censor.js kong-ent:/usr/local/kong/js-plugins

docker commit kong-ent kong-ent-js
```

## Run Kong using custom image and enable JS plugin environment variables

```
docker-compose down

docker-compose -f docker-compose-js.yaml run kong kong migrations bootstrap

docker-compose -f docker-compose-js.yaml up -d
```

## Create service and route in Kong

```
export MY_URI=$(cat /etc/hosts | grep 127.0.0.1 | tail -1 | sed 's/[^ ]* //')

http post localhost:8001/services name=strapi-jscp url=http://$MY_URI:1337/kong-js-plugins

http post localhost:8001/services/strapi-jscp/routes paths:='["/custom-jsplugin"]'

http get localhost:8000/custom-jsplugin
```

## Apply and test custom plugin

```
http post localhost:8001/services/strapi-jscp/plugins name=js-censor

http get localhost:8000/custom-jsplugin
```

## Clean up

```
docker-compose -f docker-compose-js.yaml down

docker-compose -f docker-compose-strapi.yaml down
```

