# WP Docker
Zero configuration tool for setting up Docker environment for WordPress development.

<br>
<p>
WP Docker is a CLI tool that create LAMP stack for WordPress development using Docker and Docker Compose.
<br>
Each development Environment will run into Docker containers and completely isolated.
</p>

<br>
<p>
<strong>Features:</strong>
	<li>One command, Zero configuration Docker environment setup</li>
	<li>Can access into Docker container using <code>docker-compose exec php bash</code>. Installing packages & building assets can be done isolatly here.</li>
	<li>Choose any PHP FPM version that is available in <a href="https://hub.docker.com/_/php">Docker Hub</a></li>
	<li>Choose any NODEJS version that is available in <a href="https://hub.docker.com/_/node">Docker Hub</a></li>
	<li>Choose any WordPress release version from <a href="https://wordpress.org/download/releases/">Here</a></li>
	<li>Nginx</li>
	<li>Mysql</li>
	<li>Composer</li>
	<li>PHPMyAdmin</li>
</p>

<br>
<br>

## Prerequisites
Docker, Docker Compose and CURL need to be installed in your machine. `docker` and `docker-compose` commands should run without root user permission. Currently WP Docker is going to work in Linux and MacOS.

<br>
<br>

## Installation
* Clone this repository to your Home directory `git clone git@github.com:awesomemotive/wp-docker.git`.
* Make `wp-docker/codesvault` file executable. Run: `sudo chmod +x wp-docker/codesvault`
* Add repo into your PATH.
	* If you're using ZSH then you can make an alias into `zshrc` file. `alias codesvault="~/wp-docker/codesvault"`.
	* If you're using Bash then edit your `.bashrc` and add: `export PATH=~/wp-docker:$PATH`

<br>
<br>

## Uses
Just go to your desired folder and run
``` bash
codesvault
```

<br>

When the setup process is done change directory (cd) in to the domain prefix that you have been provided.
Here all docker-compose commands also can be run. If you want to access your container just run: `docker-compose exec php bash`, in this container you will have PHP, NodeJS of your choosen version. Also have Git, Composer.
<br>
Incase if you forgate your domain or PHPMyAdmin url then just run `codesvault --routes`.
