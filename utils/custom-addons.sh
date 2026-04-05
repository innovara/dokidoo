#!/bin/sh
#
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2024,  Manuel Fombuena <mfombuena@innovara.tech>
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

git clone https://github.com/OCA/account-analytic.git --depth 1 --branch $BRANCH --single-branch odoo-data/custom-addons/account-analytic
git clone https://github.com/OCA/account-financial-reporting.git --depth 1 --branch $BRANCH --single-branch odoo-data/custom-addons/account-financial-reporting
git clone https://github.com/OCA/account-invoicing.git --depth 1 --branch $BRANCH --single-branch odoo-data/custom-addons/account-invoicing
git clone https://github.com/OCA/account-reconcile.git --depth 1 --branch $BRANCH --single-branch odoo-data/custom-addons/account-reconcile
git clone https://github.com/OCA/bank-payment --depth 1 --branch $BRANCH --single-branch odoo-data/custom-addons/bank-payment
git clone https://github.com/OCA/bank-statement-import.git --depth 1 --branch $BRANCH --single-branch odoo-data/custom-addons/bank-statement-import
git clone https://github.com/OCA/crm.git --depth 1 --branch $BRANCH --single-branch odoo-data/custom-addons/crm
git clone https://github.com/OCA/multi-company.git --depth 1 --branch $BRANCH --single-branch odoo-data/custom-addons/multi-company
git clone https://github.com/OCA/OpenUpgrade.git --depth 1 --branch $BRANCH --single-branch odoo-data/custom-addons/OpenUpgrade
git clone https://github.com/OCA/project.git --depth 1 --branch $BRANCH --single-branch odoo-data/custom-addons/project
git clone https://github.com/OCA/reporting-engine.git --depth 1 --branch $BRANCH --single-branch odoo-data/custom-addons/reporting-engine
git clone https://github.com/OCA/server-ux.git --depth 1 --branch $BRANCH --single-branch odoo-data/custom-addons/server-ux
git clone https://github.com/OCA/timesheet.git --depth 1 --branch $BRANCH --single-branch odoo-data/custom-addons/timesheet
git clone https://github.com/OCA/web.git --depth 1 --branch $BRANCH --single-branch odoo-data/custom-addons/web
git clone https://github.com/odoomates/odooapps.git --depth 1 --branch $BRANCH --single-branch odoo-data/custom-addons/odoomates

echo "\nYou most likely want to run ./utils/fix-permissions.sh now"
