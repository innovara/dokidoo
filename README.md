# dokidoo

## Introduction

**dokidoo** is a framework for deploying Odoo using Docker containers. It consists primarily of a collection of Dockerfiles and some scripts to facilitate the process.

While it is more suitable for temporary purposes (e.g. development, testing, upgrades, demos, and so on), permanent deployments have been considered, with the use of volumes for data persistence.

For the backend database, `docker-compose.yml` pulls PostgreSQL's official image from Docker Hub (https://hub.docker.com/_/postgres). For Odoo, it builds the image on the host running `docker compose`, cloning the latest version of Odoo from their GitHub repository (https://github.com/odoo/odoo).

## How to use **dokidoo**

0. Install Docker if you have not done so already: https://docs.docker.com/engine/install/

1. Clone this repository:

```bash
git clone https://github.com/innovara/dokidoo --depth 1 --branch <ODOO_VERSION> --single-branch && cd dokidoo
```

2. Set up your credentials:

```bash
nano env/postgresql.env
```

Edit `POSTGRES_PASSWORD` and `PGPASSWORD`. The former is the password for `postgres`, the superuser. The latter is the password for Odoo's database user. If you wish to use a database user other than `odoo`, edit `PGUSER` as well.

```bash
nano odoo-data/odoo.conf
```

Set `db_password = <db_user password>` to match the value of `PGPASSWORD`. If you changed `PGUSER`, you will also need to update `db_user = odoo`.

3. *(Optional)* Depending on what you are deploying, you may want to add custom addons to `odoo-data/custom-addons` at this point. Also, take a look at `./utils/custom-addons.sh`.  
**Note**: Odoo does not load addons recursively. It will ignore addons located in subfolders under `odoo-data/custom-addons`. You need to explicitly add the paths to each folder containing addons in the `addons_path` entry in `odoo-data/odoo.conf`.

4. Fix permissions (you will need root access or `sudo`):

```bash
./utils/fix-permissions.sh
```

5. Start the containers, remaining attached initially:

```bash
docker compose up
```

PostgreSQL will initialise the database server and create Odoo’s user. A new folder named `./db-data` will be created on the host for data persistence. PostgreSQL’s image will not reinitialise the server on subsequent runs; it will simply use the contents of `./db-data`.

To reinitialise the database, delete the `./db-data` folder. **Note:** this will delete all data on the database server.

6. After you have confirmed that Odoo's container is awaiting connection, stop the containers with `Ctrl+C`.

7. Fix permissions again (you will need root access or `sudo`):

```bash
./utils/fix-permissions.sh
```

8. Start the containers attached again:

```bash
docker compose up
```

9. Open `0.0.0.0:8069` in your browser, set your admin password, create your Odoo database, install modules, and so on.  
The URL may differ if you are using a headless server or a reverse proxy such as nginx. Also, ensure your firewall is configured to allow access if running this on a separate machine.

10. Once you have completed the initial setup, you can stop Docker Compose with `Ctrl+C` and restart it in detached mode:

```bash
docker compose up -d
```

## Modifications

There is an increased risk of things not working as expected, or failing entirely, if you make changes. However, if you want to adapt **dokidoo**, start with `docker-compose.yml`.

Currently, `./Dockerfile` is a symbolic link to `./docker/Dockerfile`. There are additional Docker build files under `./docker`, which are not used by default, but may be of interest. In particular:

- `requirements.Dockerfile` – builds Python 3 modules using pip and Odoo's `requirements.txt`, rather than using precompiled packages.
- `bookworm.Dockerfile` – based on Debian 12 (Bookworm).
- `focal.Dockerfile` – based on Ubuntu 20.04 (Focal).
- `jammy.Dockerfile` – based on Ubuntu 22.04 (Jammy).

You can either modify `docker-compose.yml` to point to one of these files, or change the symbolic link to use the desired build file.

## Use **dokidoo** for upgrades

Using **dokidoo** to upgrade Odoo between major versions has proved very efficient in my experience.  
Please note that you will need to edit `docker-compose.yml` to keep PostgreSQL on the same version while upgrading Odoo. Once you reach your target Odoo version, you may also upgrade PostgreSQL.

If you would like to perform this kind of upgrade and need assistance, refer to the Support section below.

## Feedback

Please read the Support section before submitting feedback.

I initially focused on Odoo 14.0, which was the version I was using at the time. As I upgraded my instance to 17.0, I created other branches with the minor changes needed for them to work.

Feedback is especially welcome regarding versions 15.0 and 16.0, which I did not use extensively, and 18.0, which has been tested only to the extent that I could create a database and log in.

## Support

As per the GPL-3.0 licence:

```
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

I am an IT consultant and can provide services to help you with Odoo in your environment, whether using **dokidoo** or not. There are also many other consultants who can do the same.  
If you are on a tight budget or do not wish to spend money on a particular issue, there are other projects and community forums where you can ask for help.

Please note that this is not a vocational project to which I will dedicate hours of support. I am sharing the result of a considerable amount of work so that others may benefit and build upon it, just as I have benefited from others' work.

Since **dokidoo** is primarily a collection of third-party tools, problems are more likely to originate from those tools. You should report such issues upstream.

However, if you discover something in **dokidoo** that does not work in specific situations or could be improved, please report it and I will be happy to look into it.
