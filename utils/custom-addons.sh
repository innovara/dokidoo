#!/bin/sh
#
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2024,  Manuel Fombuena <fombuena@outlook.com>
#
# Custom list of addons for easy deployment
#
# Each repo folder has to be added to addons_path= in odoo.conf e.g. /opt/dokidoo/odoo/custom-addons/account-reconcile
#
# ./utils/custom-addons.sh <ODOO_VERSION>
#
# e.g. ./utils/custom-addon.sh 14.0
#

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <ODOO_VERSION> .e.g $0 14.0" >&2
  exit 1
fi

BRANCH=$1

mkdir -p odoo-data/custom-addons

git clone https://github.com/OCA/account-reconcile.git --depth 1 --branch $BRANCH --single-branch odoo-data/custom-addons/account-reconcile
git clone https://github.com/OCA/bank-statement-import.git --depth 1 --branch $BRANCH --single-branch odoo-data/custom-addons/bank-statement-import
git clone https://github.com/OCA/OpenUpgrade.git --depth 1 --branch $BRANCH --single-branch odoo-data/custom-addons/OpenUpgrade
git clone https://github.com/OCA/reporting-engine.git --depth 1 --branch $BRANCH --single-branch odoo-data/custom-addons/reporting-engine
git clone https://github.com/OCA/timesheet.git --depth 1 --branch $BRANCH --single-branch odoo-data/custom-addons/timesheet
git clone https://github.com/OCA/web.git --depth 1 --branch $BRANCH --single-branch odoo-data/custom-addons/web
git clone https://github.com/odoomates/odooapps.git --depth 1 --branch $BRANCH --single-branch odoo-data/custom-addons/odoomates

echo "You possibly want to run ./utils/fix-permissions.sh now"
