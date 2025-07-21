FROM alpine:3.22.1

RUN apk add --no-cache curl iputils && \
    adduser --gecos "" --no-create-home --shell /bin/false --disabled-password --uid 1000 ddns-updater

COPY --chmod=555 --chown=0:0 ddns_updater.sh /ddns_updater.sh

USER ddns-updater

CMD [ "/ddns_updater.sh" ]
