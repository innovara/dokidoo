# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2024,  Manuel Fombuena <fombuena@outlook.com>

FROM alpine:latest AS transient
ARG ODOO_VERSION
RUN apk update && \
    apk add wget git
ARG TARGETARCH
RUN case "$TARGETARCH" in \
        amd64) arch=$TARGETARCH ;; \
        arm64) arch=$TARGETARCH ;; \
        ppc64le) arch=$TARGETARCH ;; \
        *) echo >&2 "error: unsupported architecture: $TARGETARCH"; exit 1 ;; \
    esac; \
    wget -O wkhtmltox_0.12.6.1-3.deb https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.jammy_${arch}.deb
WORKDIR /odoo
RUN git clone https://github.com/odoo/odoo --depth 1 --branch ${ODOO_VERSION} --single-branch


FROM ubuntu:jammy
COPY --from=transient /wkhtmltox_0.12.6.1-3.deb .
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt install --yes --no-install-recommends \
        ./wkhtmltox_0.12.6.1-3.deb \
        gsfonts \
        libfontenc1 \
        postgresql-client \
        python3-babel \
        python3-chardet \
        python3-dateutil \
        python3-decorator \
        python3-docutils \
        python3-feedparser \
        python3-geoip2 \
        python3-gevent \
        python3-greenlet \
        python3-html2text \
        python3-jinja2 \
        python3-ldap \
        python3-libsass \
        python3-lxml \
        python3-mako \
        python3-markupsafe \
        python3-mock \
        python3-num2words \
        python3-ofxparse \
        python3-openssl \
        python3-passlib \
        python3-pillow \
        python3-polib \
        python3-psutil \
        python3-psycopg2 \
        python3-pydot \
        python3-pyparsing \
        python3-pypdf2 \
        python3-qrcode \
        python3-renderpm \
        python3-reportlab \
        python3-requests \
        python3-rjsmin \
        python3-serial \
        python3-stdnum \
        python3-tz \
        python3-usb \
        python3-vobject \
        python3-werkzeug \
        python3-xlrd \
        python3-xlsxwriter \
        python3-xlwt \
        python3-zeep \
        xfonts-75dpi \
        xfonts-base \
        xfonts-encodings \
        xfonts-utils && \
    rm ./wkhtmltox_0.12.6.1-3.deb && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*
RUN adduser --system --uid 8069 --group --home=/opt/dokidoo dokidoo
COPY --from=transient --chown=dokidoo:dokidoo /odoo /opt/dokidoo/
COPY --chown=dokidoo:dokidoo ./docker/entrypoint.sh /opt/dokidoo/
USER dokidoo
WORKDIR /opt/dokidoo
ENTRYPOINT ["./entrypoint.sh"]
