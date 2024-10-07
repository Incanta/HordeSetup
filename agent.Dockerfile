FROM ubuntu:22.04

ARG HORDE_SERVER_URL="http://10.0.0.10:13340"

# Dependencies
RUN apt-get update
RUN apt-get install -y wget
RUN dpkg --add-architecture i386
RUN mkdir -pm755 /etc/apt/keyrings
RUN wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
RUN wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources
RUN apt-get update
RUN apt-get install -y wget
RUN apt-get install -y unzip
RUN apt-get install -y dotnet-sdk-6.0 dotnet-sdk-8.0
RUN apt-get install -y --install-recommends winehq-stable
RUN apt-get install -y jq

# Set up wine
RUN mkdir -p /opt/horde/wine-data
RUN WINEPREFIX=/opt/horde/wine-data wineboot --init
COPY uba-wine64.sh /usr/bin/uba-wine64.sh
RUN chmod +x /usr/bin/uba-wine64.sh

# Horde Agent
RUN mkdir /app
RUN wget ${HORDE_SERVER_URL}/api/v1/agentsoftware/default/zip -O /app/HordeAgent.zip
RUN unzip -o /app/HordeAgent.zip -d /app
WORKDIR /app
RUN HORDE_SERVER_TOKEN=$(wget -qO- ${HORDE_SERVER_URL}/api/v1/admin/registrationtoken)
RUN dotnet HordeAgent.dll SetServer -Name=HordeServer -Url=${HORDE_SERVER_URL} -Default -Token=${HORDE_SERVER_TOKEN}
RUN jq '.Horde.wineExecutablePath = "/usr/bin/uba-wine64.sh"' appsettings.json > appsettings.json.tmp && mv appsettings.json.tmp appsettings.json

ENTRYPOINT [ "dotnet", "HordeAgent.dll" ]