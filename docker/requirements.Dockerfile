# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2024,  Manuel Fombuena <fombuena@outlook.com>

FROM alpine:latest AS transient
ARG ODOO_VERSION
RUN apk update && \
    apk add wget git
ARG TARGETARCH
RUN case $TARGETARCH in \
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
ARG DEPEN_PKGS="python3 libpq5 postgresql-client"
ARG BUILD_PKGS="g++ gcc libjpeg-dev libldap-dev libpq-dev libsasl2-dev patch pip python3-dev"
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt install --yes --no-install-recommends \
        ./wkhtmltox_0.12.6.1-3.deb \
        $DEPEN_PKGS \
        $BUILD_PKGS && \
    rm ./wkhtmltox_0.12.6.1-3.deb
COPY --from=transient /wkhtmltox_0.12.6.1-3.deb .
RUN adduser --system --uid 8069 --group --home=/opt/dokidoo dokidoo
COPY --from=transient --chown=dokidoo:dokidoo /odoo /opt/dokidoo/
COPY --chown=dokidoo:dokidoo ./patches /opt/dokidoo/
USER dokidoo
WORKDIR /opt/dokidoo
RUN for p in *.patch ; do patch odoo/requirements.txt < $p ; done && \
    rm *.patch
RUN pip install --no-cache-dir -r odoo/requirements.txt
USER root
RUN apt update && \
    apt autoremove --purge --yes \
        $BUILD_PKGS && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*
COPY --chown=dokidoo:dokidoo ./docker/entrypoint.sh /opt/dokidoo/
USER dokidoo
WORKDIR /opt/dokidoo
ENTRYPOINT ["./entrypoint.sh"]
