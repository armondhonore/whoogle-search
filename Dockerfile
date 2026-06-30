FROM mirror.gcr.io/library/python:3.12-alpine3.22 AS builder

RUN apk --no-cache add \
    build-base \
    libxml2-dev \
    libxslt-dev \
    openssl-dev \
    libffi-dev

COPY requirements.txt .

RUN pip install --upgrade pip
RUN pip install --prefix /install --no-warn-script-location --no-cache-dir -r requirements.txt

FROM mirror.gcr.io/library/python:3.12-alpine3.22

RUN apk add --no-cache --no-scripts tor curl openrc libstdc++ && \
    apk del --no-cache bridge || true
RUN pip install --upgrade pip
RUN apk --no-cache upgrade && \
    apk del --no-cache --rdepends bridge || true

ARG DOCKER_USER=whoogle
ARG DOCKER_USERID=927
ARG config_dir=/config
RUN mkdir -p $config_dir
RUN chmod a+w $config_dir
VOLUME $config_dir

ENV CONFIG_VOLUME=$config_dir \
    WHOOGLE_URL_PREFIX="" \
    WHOOGLE_USER="" \
    WHOOGLE_PASS="" \
    WHOOGLE_PROXY_USER="" \
    WHOOGLE_PROXY_PASS="" \
    WHOOGLE_PROXY_TYPE="" \
    WHOOGLE_PROXY_LOC="" \
    WHOOGLE_DOTENV="" \
    HTTPS_ONLY="" \
    EXPOSE_PORT=5000

WORKDIR /whoogle

COPY --from=builder /install /usr/local
COPY misc/tor/torrc /etc/tor/torrc
COPY misc/tor/start-tor.sh misc/tor/start-tor.sh
COPY app/ app/
COPY run whoogle.env* ./

RUN chmod +x run misc/tor/start-tor.sh

EXPOSE 5000
ENV PORT=5000

CMD ["./run"]