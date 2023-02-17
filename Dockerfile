FROM eclipse-mosquitto

# RUN apk add jq

RUN apk add --no-cache bash

COPY ./start.sh ./start.sh
RUN ["chmod", "+x", "./start.sh"]

ENTRYPOINT ["/bin/bash", "./start.sh"]