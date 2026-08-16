FROM eclipse-temurin:25-jre AS builder

ENV SERVER_ZIP=https://edge.forgecdn.net/files/8611/211/Meatballcraft-Server-prerelease-0.18.6.3.zip

RUN  apt-get update \
  && apt-get install -y wget unzip\
  && rm -rf /var/lib/apt/lists/*

# RUN mkdir /tmp/minecraft && cd /tmp/minecraft && \
# 	wget --timeout=60 --quiet -c ${SERVER_ZIP} -O server.zip && \
# 	unzip -q server.zip && \
# 	rm server.zip && \
#   echo "eula=true" > /tmp/minecraft/eula.txt
# ADD Meatballcraft-Server-prerelease-0.18.6.3.zip /tmp/server.zip

RUN cd /tmp && \
	wget --timeout=60 --quiet -c ${SERVER_ZIP} -O server.zip && \
    unzip -q server.zip && \
    rm server.zip && \
    mv Meatballcraft-Server-prerelease-0.18.6.3 minecraft && \
    cd minecraft && \
    ls -al && \
    echo "eula=true" > /tmp/minecraft/eula.txt


RUN cd /tmp/minecraft/mods && \
    rm cells-0.6.7-beta.jar && \
	wget --timeout=60 --quiet -c https://edge.forgecdn.net/files/8634/93/cells-0.6.7-beta2.jar -O cells-0.6.7-beta2.jar

RUN cd /tmp/minecraft && \
    sed -i "s/USE_CLEANROOM=false/USE_CLEANROOM=true/g" settings.cfg && \
    cat settings.cfg && \
    bash ServerStart.sh install 

RUN cd /tmp/minecraft && ls -al && sleep 10

ADD server.properties /tmp/minecraft/server.properties
ADD wrapstart.sh /tmp/minecraft/wrapstart

FROM eclipse-temurin:25-jre

EXPOSE 25565
EXPOSE 25575


WORKDIR /data

VOLUME /data/world

COPY --from=builder /tmp/minecraft/. ./
CMD /data/wrapstart

ENV MOTD="A Minecraft (MeatballCraft) Server Powered by Docker"
ENV LEVEL="world"
ENV JVM_OPTS="-Xms4096m -Xmx8192M"
