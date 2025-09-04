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
	<li>Can access into Docker container using <code>docker-compose exec php bash</code>. Installing composer packages.</li>
	<li>Choose any PHP FPM version that is available in <a href="https://hub.docker.com/_/php">Docker Hub</a></li>
	<li>Choose any NODEJS version. Build assets isolatly in this container.</li>
	<li>Choose any WordPress release version from <a href="https://wordpress.org/download/releases/">Here</a></li>
	<li>Nginx</li>
	<li>Mysql</li>
	<li>PHPMyAdmin</li>
	<li>WP CLI</li>
</p>

<br>
<br>

## Prerequisites
Docker, Docker Compose and CURL need to be installed in your machine. `docker` and `docker-compose` commands should run without root user permission. Currently WP Docker is going to work in Linux and MacOS.

<br>
<br>

## Installation
* Download the `codesvault.zip` from [latest release](https://github.com/CodesVault/wp-docker/releases/tag/v1.1.0)
* Make `codesvault/wp-docker` file executable. Run: `sudo chmod +x codesvault/wp-docker`
* Add repo into your PATH.
	* If you're using ZSH then you can make an alias into `zshrc` file. `alias wp-docker="~/codesvault/wp-docker"`.
	* If you're using Bash then edit your `.bashrc` and add: `export PATH=~/codesvault/wp-docker:$PATH`

<br>
<br>

## Uses
Just go to your desired folder and run
``` bash
wp-docker
```

<br>

When the setup process is done change directory (cd) in to the domain prefix that you have been provided.
Here Docker configurations and WordPress is ready to use.
<br>
Incase if you forgate your domain or PHPMyAdmin url then just run `wp-docker --routes`.

<br>
<br>

## Contributors

| Name| Github username |
| ----------- | ----------- |
| AbmSourav      | [@AbmSourav](https://github.com/AbmSourav)   |
