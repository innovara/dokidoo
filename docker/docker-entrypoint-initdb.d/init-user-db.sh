#!/bin/bash
#
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2024,  Manuel Fombuena <fombuena@outlook.com>
#

set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	CREATE USER odoo CREATEDB NOCREATEROLE NOSUPERUSER PASSWORD '$PGPASSWORD';
EOSQL
