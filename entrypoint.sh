#!/bin/bash

if [ -z "$MC_VERSION" ]; then
  echo "MC_VERSION is not set"
  exit 1
fi

if [ -z "$MC_RAM" ]; then
  echo "MC_RAM is not set"
  exit 1
fi

LATEST_BUILD=$(curl -s "https://papermc.io/api/v2/projects/paper/versions/${MC_VERSION}" | jq '.builds[-1]')
LATEST_DOWNLOAD=$(curl -s "https://papermc.io/api/v2/projects/paper/versions/${MC_VERSION}/builds/${LATEST_BUILD}" | jq '.downloads.application.name' -r)
echo -----------------
echo $MC_VERSION#$LATEST_BUILD
echo -----------------
PAPERMC_DOWNLOAD_URL="https://papermc.io/api/v2/projects/paper/versions/${MC_VERSION}/builds/${LATEST_BUILD}/downloads/${LATEST_DOWNLOAD}"
curl -s -o paperclip.jar ${PAPERMC_DOWNLOAD_URL}


filesize=$(stat -c%s "paperclip.jar")
if [[ $filesize -lt 10240 ]]; then
    echo "WARNING. JAR IS SMALLER THAN 10K. DID YOU SELECT A VALID GAME VERSION?"
    cat paperclip.jar
    exit 255
else
    echo "File seems to be fine :)"
fi

echo "eula=true" > eula.txt

echo "starting minecraft ${MC_VERSION}"
java -Xmx${MC_RAM}G -jar paperclip.jar nogui
