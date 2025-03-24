# dokidoo

## Introduction

**dokidoo** is a framework to deploy Odoo using Docker containers. It comprises mostly a collection of Docker files and some scripts to facilitate the process.

While it is more suitable for temporary purposes e.g. development, testing, upgrades, demos, and so on, permanent deployments have been taken into account with the use of volumes for persisting data.

For the backend db, `docker-compose.yml` pulls PostgreSQL's official image from Docker Hub (https://hub.docker.com/_/postgres). For Odoo, it builds the image on the host running `docker compose`, cloning the latest version of Odoo from their git repository on GitHub (https://github.com/odoo/odoo).

## How to use **dokidoo**

0. Install docker if you haven't done so yet: https://docs.docker.com/engine/install/

1. Clone this repository.

`git clone https://github.com/innovara/dokidoo --depth 1 --branch <ODOO_VERSION> --single-branch && cd dokidoo`

2. Set up your credentials.

`nano env/postgresql.env`

Edit `POSTGRES_PASSWORD` and `PGPASSWORD`. The former is postgres', the super user, password. The later is Odoo's db user password. If you want to use a db user for Odoo that is not odoo, edit `PGUSER` too.

`nano odoo-data/odoo.conf`

Edit `db_password = <db_user password>` with the password used on `PGPASSWORD`. If you changed `PGUSER`, you have to also change `db_user = odoo` here.

3. Optional. Depending on what you are deploying, you might want to add custom addons to `odoo-data/custom-addons` now. Also take a look at `./utils/custom-addons.sh`.
Please note that Odoo doesn't load addons recursively. It will ignore addons in subfolders under `odoo-data/custom-addons`. You need to add each path to folders containing addons to `addons_path` in `odoo-data/odoo.conf`.

4. Fix permissions. You will need to be root or use sudo.

`./utils/fix-permissions.sh`

5. Bring the containers up, staying attached first.

`docker compose up`

postgres will initialize the db server and add Odoo's user. A new folder named `./db-data` will be created on the host for persisting data. PostgreSQL's image will not initilize the db server a second time, and it will simply use whatever it is in `./db-data`.
To initialize the db again, delete `./db-data`. Doing so of course deletes all the data on the db server. 

6. Go to `0.0.0.0:8069` on a browser, set up your admin password, create your Odoo db, install modules and so on. The URL will vary if you are using a headless server or a reverse proxy like nginx. Also, don't forget about your firewall if you are running this on another machine.

7. Once you've passed the initial stages of the setup, you can stop docker compose with Ctrl+c and bring it back up again, detached this time.

`docker compose up -d`

## Modifications

There are more chances of things not working as expected, or not working at all, if you make changes. However, if you want to adapt **dokidoo**, the starting point is `docker-compose.yml`. Currently `./Dockerfile` points to `./docker/Dockerfile`. There are other Docker build files under `./docker` which are not used, but you should take a look at them. Particularly `./docker/requirements.Dockerfile` which doesn't use pre-compiled packages for the python3 modules and it builds them with pip, using Odoo's `requirements.txt` file. Also `bookworm.Dockerfile` might be of interest if you prefer Debian. You can edit `docker-compose.yml` to point to these files, or leave it as it is and change the symbolic link to the build file that you want to try.

## Use **dokidoo** for upgrades

Using **dokidoo** to upgrade Odoo between major versions has proved to be very efficient in my experience. Just please note that you will have to edit `docker-compose.yml` to keep PostgreSQL on the same version while you keep bumping Odoo. Once you are at the Odoo version that you want, it is also possible to upgrade PostgreSQL.

If you want to do something like this but need help, please see the Support section.

## Feedback

First, please read the Support section.

I initially focused on Odoo 14.0, a relatively old version, because that is what I was using at the time. As I worked my way through upgrading my instance to 17.0, I created the other branches with the small changes needed for it to work. Feedback is especially welcomed on 15.0 and 16.0, which I didn't use for any meaningful amount of time, and 18.0, which is tested to the point I can create a db and log in.

## Support

As the GPL-3.0 license goes:
```
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```
I am an IT consultant and I can provide services to help you with Odoo in your environment, using **dokidoo** or otherwise. There is also a healthy number of consultants out there who can do the same. And if you are on a tight budget, or you don't want to spend money on a particular issue affecting you, there are other projects and community forums where you can ask for help. The bottom line is that this is not a vocational project to which I am going to devote hours to support Odoo users. I want to share the output of a non-trivial amount of time dedicated to the project, so others can use it and build on that, like I have done countless times with someone else's work.

Since **dokidoo** is mostly a collection of third-party tools, you are more likely to encounter problems with those and you should report them upstream. However, if you found something on **dokidoo** that doesn't work on certain situations, or it could be done better, please report it and I will be happy to look into it.
