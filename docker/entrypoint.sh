#!/bin/sh
#
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2024,  Manuel Fombuena <mfombuena@innovara.tech>
#

PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin
DAEMON=/opt/dokidoo/odoo/odoo-bin
CONFIG=/opt/dokidoo/odoo.conf

$DAEMON --config $CONFIG
