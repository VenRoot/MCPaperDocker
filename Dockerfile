FROM openjdk:17-slim-bullseye

WORKDIR /app

RUN apt update -y
RUN apt install curl jq -y

COPY entrypoint.sh .

CMD ["bash", "entrypoint.sh"]
