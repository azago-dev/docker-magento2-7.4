![Magento 2](https://cdn.rawgit.com/rafaelstz/magento2-snippets-visualstudio/master/images/icon.png)

#  Magento 2 Docker to Development

### Apache 2.4 + PHP 7.0 + OPCache + MariaDB + N98 Magerun 2 + XDebug + Redis

### Requirements

**MacOS:**

Install [Docker](https://docs.docker.com/docker-for-mac/install/), [Docker-compose](https://docs.docker.com/compose/install/#install-compose) and [Docker-sync](https://github.com/EugenMayer/docker-sync/wiki/docker-sync-on-OSX).

**Windows:**

Install [Docker](https://docs.docker.com/docker-for-windows/install/), [Docker-compose](https://docs.docker.com/compose/install/#install-compose) and [Docker-sync](https://github.com/EugenMayer/docker-sync/wiki/docker-sync-on-Windows).

**Linux:**

Install [Docker](https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/) and [Docker-compose](https://docs.docker.com/compose/install/#install-compose).

### How to use

Execute in your terminal, change the *MYMAGENTO2* to use the name of your project:

```
curl -s https://raw.githubusercontent.com/redstage/docker-linux-init/master/magento2/init | bash -s MYMAGENTO2 clone
```

If you want to install the Magento 2, use like that:

```
cd MYMAGENTO2
./shell
rm index.php
install-magento2
```

You can specify the version that want install (e.g. `install-magento2 2.2`).

### Panels

Enjoy your new panels!

**Web server:** http://localhost/

**PHPMyAdmin:** http://localhost:8080

**Local emails:** http://localhost:8025

### Features commands

| Commands  | Description  | Options & Examples |
|---|---|---|
| `./init`  | If you didn't use the CURL setup command above, please use this command changing the name of the project.  | `./init MYMAGENTO2` |
| `./start`  | If you continuing not using the CURL you can start your container manually  | `./start loadbalancer` or `./start varnish` |
| `./stop`  | Stop your project containers  | |
| `./kill`  | Stops containers and removes containers, networks, volumes, and images created to the specific project  | |
| `./shell`  | Access your container  | `./shell root` `./shell root apache_container` | |
| `./magento`  | Use the power of the Magento CLI  | `./magento apache_container clean:cache` |
| `./n98`  | Use the Magerun commands as you want | `./n98 apache_container mage_run_command` |
| `./grunt-init`  | Prepare to use Grunt  | `./grunt-init apache_container` |
| `./grunt`  | Use Grunt specifically in your theme or completely, it'll do the deploy and the watcher.  | `./grunt luma` or `./grunt luma apache_container` |
| `./xdebug`  |  Enable / Disable the XDebug | `./xdebug` or `./xdebug apache_container` |
| `./composer`  |  Use Composer commands | `./composer update` or `composer update apache_container` |
| `./import`  |  import the database into db container and update your domain | `./import file.sql yourlocaldomain.com`|
| `./copy`  |  Copy a file from your computer to db docker container | `./copy file.sql`|
| `./delete`  |  Delete a file from db docker container | `./delete file.sql`|
| `./updateUrl`  |  update your URL from 'web/secure/base_url', 'web/unsecure/base_url'| `./updateUrl yourlocaldomain.com`|

### Elasticsearch 

To use elastic search you can use this command below:

`$ docker-compose -f docker-compose.yml -f docker-compose.elasticsearch.yml up`

or to run in the background using detached mode

`$ docker-compose -f docker-compose.yml -f docker-compose.elasticsearch.yml up -d`

**Elasticsearch:** http://localhost:9200

### Selenium 

To use selenium container you can use this command below:

`$ docker-compose -f docker-compose.yml -f docker-compose.selenium.yml up`

or to run in the background using detached mode

`$ docker-compose -f docker-compose.yml -f docker-compose.selenium.yml up -d`

**Selenium:** http://localhost:4444

### Docker Sync (Windows and Mac)

On Windows and Mac make sure your docker-sync.yml file is properly set.
Under `src` option make sure it reflects the Magento root folder, if not, update it accordingly.

**Example:** You cloned your Magento project inside a folder called 'my_project': `docker-structure/src/my_project`.

Update docker-sync.yml with:

```
	...
	src: './src/my_project'
	...
```

So docker will synchronize correctly the VM and Host folders and ignore not needed files.

### License
This project is based in
[Rafael Corrêa Gomes](https://github.com/rafaelstz/) docker environment: https://github.com/clean-docker/Magento2
