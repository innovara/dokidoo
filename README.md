# dokidoo

## Introduction

**dokidoo** is a framework to easily deploy Odoo via Docker containers. It comprises mostly a collection of Docker files and some scripts to facilitate the process.

While it is naturally more suitable for temporary purposes e.g. testing and development, demos and so on, its use on permanent deployments has been taken into consideration and volumes are used for persisting data.

Currently, `docker-compose.yml` pulls PostgreSQL's official image from Docker Hub (https://hub.docker.com/_/postgres) for the backend db, and it builds Odoo's image on the host running `docker compose`. Odoo's image clones the latest version of Odoo from their git repository on GitHub (https://github.com/odoo/odoo).

## How to use dokidoo

0. Install docker if you haven't done so yet: https://docs.docker.com/engine/install/

1. Clone repository.

`git clone https://github.com/innovara/dokidoo --depth 1 --branch <ODOO_VERSION> --single-branch && cd dokidoo`

2. Set up your credentials.

`nano env/postgresql.env`

Edit `POSTGRES_PASSWORD=<super user password>` and `PGPASSWORD=<db_user password>`. The former is postgres', the super user, password and the later is Odoo's db user password. You could also change `PGUSER=odoo` if you wanted to use something else.

`nano odoo-data/odoo.conf`

Edit `db_password = <db_user password>` with the password used on `PGPASSWORD`. If you changed `PGUSER=odoo`, you have to also change `db_user = odoo` here.

3. Optional. Depending on what you are deploying, you might want to add custom addons to `odoo-data/custom-addons` now. Please note that Odoo doesn't load addons recursively and it will ignore those placed in subfolders under `odoo-data/custom-addons`. Take a look at `utils\custom-addons.sh`. If you used something like that, you would need to add each path to `addons_path` in `odoo-data/odoo.conf` for Odoo to load them.

4. Fix permissions. You will need to be root or use sudo.

`./utils/fix-permissions.sh`

5. Bring the containers up, remaining attached first.

`docker compose up`

postgres will initialize the db server and add Odoo's user. A new folder named `./db-data` will be created on the host for persisting data. If you wanted, or needed, to initialize the db again, you have to delete this folder which of course deletes all the data on the db server. PostgreSQL's image will not initilize the db server a second time and it will simply use whatever is in there.

6. Go to `0.0.0.0:8069` on a browser, set up your admin password, create your Odoo db, install modules and so on. The URL will of course vary if you are using a headless server, a reverse proxy like nginx, etc. Also don't forget about your firewall if you are running this on another machine.

7. Once you've passed the initial stages of the setup, you can stop docker compose with Ctrl+c and bring it up again, detached this time.

`docker compose up -d`

## Modifications

There are obviously more chances of things not working as expected, or not working at all, if you make changes. However, if you want to adapt **dokidoo**, the starting point is `docker-compose.yml`. Currently `./Dockerfile` points to `./docker/Dockerfile`. There are other Docker build files under `./docker` which are not used, but you should take a look at them. Particularly `./docker/requirements.Dockerfile` which doesn't use pre-compiled packages for the python3 modules and it builds them with pip, using Odoo's `requirements.txt` file. Also `bookworm.Dockerfile` might be of interest if you prefer Debian. You can edit `docker-compose.yml` to point to these files or leave it as it is and change the symbolic link to the build file that you want to try.

## Future plans

I focused on Odoo 14.0 which is a relatively old version because that is what I am using at the moment. It includes most of the functionalities that I need, some of which have been taken away from the Community Edition. It also offers a healthy number of add-ons which are also more stable than newer versions of the same, if they are available at all.

I plan to create more branches of **dokidoo** to match each major version of Odoo starting with 15.0 all the way to the latest at present, 18.0. Those will be tested to the point where I can create Odoo's db and install some of their core add-ons. Feedback is especially welcomed on those versions but please read the Support section.

## Support

As the GPL-3.0 license goes:
```
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```
I am a consultant and I can provide paid services to help you with Odoo in your environment, using **dokidoo** or otherwise. There is also a healthy number of consultants out there who can do the same. And if you are on a tight budget, or you don't want to spend money on a particular issue you might have, there are other projects and community forums where you can ask for help. The bottom line is that this is not a vocational project to which I am going to devote hours to help people to get it all working or to use Odoo. I put a non-trivial amount of time to the project and I want to share the output with others so they can use it and build on that, like I have done countless times with the work that others kindly shared.

Having said that, **dokidoo** is mostly a collection of third-party tools, so you are more likely to encounter problems with those which you would have to report upstream. However, if you found something that is done in such way that that it doesn't work on certain situations, or it could be done better, please report it.
