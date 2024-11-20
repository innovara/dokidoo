#!/bin/sh
#
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2024,  Manuel Fombuena <fombuena@outlook.com>
#
# This is a development script to rebuild the container while testing
#
# ./utils/build.sh <ODOO_VERSION>
#
# e.g. ./utils/build.sh 14.0
#

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <ODOO_VERSION> .e.g $0 14.0" >&2
  exit 1
fi

docker container stop odoo
docker container rm odoo
docker build -t odoo:$1 --build-arg ODOO_VERSION=$1 -f Dockerfile .
docker run --name odoo -d -p 0.0.0.0:8069:8069 odoo:$1
