#!/bin/sh
#
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2024,  Manuel Fombuena <mfombuena@innovara.tech>
#
# Changes the owner:group of the local folder used as volume
# to the uid:gid of dokidoo:dokidoo on the container.
#

if [ $(id -u) -ne 0 ]; then
  echo "Please run this script as root or using sudo!"
  exit 1
fi

chown 8069:8069 -R odoo-data/*
