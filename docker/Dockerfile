FROM debian:stable-slim

# Maintained original labels
LABEL maintainer.0="João Fonseca (@joaopaulofonseca)" \
  maintainer.1="Pedro Branco (@pedrobranco)" \
  maintainer.2="Rui Marinho (@ruimarinho)"

# creating user, updating os, installing curl and gpg 
RUN useradd -r litecoin \
  && apt-get update -y \
  && apt-get install -y curl gnupg \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

# installing gpg keys, some servers have been removed as seems invalid

#-> gosu public key
RUN gpg --no-tty --keyserver keys.openpgp.org --recv-keys "B42F6819007F00F88E364FD4036A9C25BF357DD4"

#-> litecoin public key
RUN gpg --no-tty --keyserver pgp.mit.edu --recv-keys "FE3348877809386C" 

# Defining gosu version
ENV GOSU_VERSION=1.10

# Downloading and verifying gosu
RUN curl -o /usr/local/bin/gosu -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture) \
  && curl -o /usr/local/bin/gosu.asc -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture).asc \
  && gpg --verify /usr/local/bin/gosu.asc \
  && rm /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu

# Setting Litecoin version
ENV LITECOIN_VERSION=0.18.1

# Downloading and verifying litecoing bin -> didn't re-engineered this as the verification was already part of the dockerfile
RUN curl -SLO https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/linux/litecoin-${LITECOIN_VERSION}-x86_64-linux-gnu.tar.gz \
  && curl -SLO https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/linux/litecoin-${LITECOIN_VERSION}-linux-signatures.asc \
  && gpg --verify litecoin-${LITECOIN_VERSION}-linux-signatures.asc \
  && grep $(sha256sum litecoin-${LITECOIN_VERSION}-x86_64-linux-gnu.tar.gz | awk '{ print $1 }') litecoin-${LITECOIN_VERSION}-linux-signatures.asc \
  && tar --strip=2 -xzf *.tar.gz -C /usr/local/bin \
  && rm *.tar.gz

# Copying shell script
COPY docker-entrypoint.sh /entrypoint.sh

# Giving exec permission to script
RUN chmod +x /entrypoint.sh

# Defining a volume
VOLUME ["/home/litecoin/.litecoin"]

# Exposing ports
EXPOSE 9332 9333 19332 19333 19444

# Configuring entrypoint and command
ENTRYPOINT ["/entrypoint.sh"]

CMD ["litecoind"]
