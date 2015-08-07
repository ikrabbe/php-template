# PHP Template

This project can be used --bare or non-bare to install a webroot serving php files with rules for apache2.4 or nginx, through php-fpm.

## Git alias setup

I often use some handy git alias commands to help installing the template into several installation directories (called `install.path`)

	git config alias.live '!git --work-tree $(git config --get live.path) '
	git config alias.showfile '!git show `git ls-tree HEAD -- "${FILE}"|awk '"'"'{print $3;}'"'"'`'
	git config alias.inst '!git --work-tree $(git config --get install.path)'
	git config alias.cdinst '!cd $(git config --get install.path); '
	git config alias.cdlive '!cd $(git config --get live.path); '

_These aliases command-lines work only if you perfectly quote all characters with trailing whitespaces and `'"'"'` quotes, just as given above._

## Installation and Test Setups

Normally I use `--bare` repositories to control `live` and `install` paths. For `install` rules see the `guide` file too.

The __live.path__ is a work-tree that is controlled by another user, such as root, different from the repository owner on the system.
The __install.path__ is used to install a webroot. To allow automagic installation as shown in the `guide` file, you have to set

	git config install.path PATH/TO/YOUR/WEBROOT
	git config install.vhost 'YOUR.VHOST-NAME-FOR-THIS.WEB'
	git config install.vhostfile 'HOW_THE_VHOST_INCLUDE_FILE_IS_NAMED'

The `vhostfile` is something that will be linked into `/etc/apache2/sites-enabled` and/or `/etc/nginx/sites-enabled`. If your system uses other — __more sane__ — directory structures for the web services, you have to change the rules in `guide` and `setup.sh` to match your system.

# TODO

1. Add the install rules from the guide file to setup.sh.
2. Describe the installation process in detail.
