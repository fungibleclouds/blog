---
layout: post
title: "Homebrew mysql"
date: 2012-08-2 09:02
comments: true
categories: 
---
[Homebrew](http://mxcl.github.com/homebrew/) certainly makes my life simple. This morning it took just 84 seconds to install mysql from source.

{%codeblock%}
brew install mysql
{%endcodeblock%}

{%codeblock%}
Set up databases to run AS YOUR USER ACCOUNT with:
    unset TMPDIR
    mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp

To set up base tables in another folder, or use a different user to run
mysqld, view the help for mysqld_install_db:
    mysql_install_db --help

and view the MySQL documentation:
  * http://dev.mysql.com/doc/refman/5.5/en/mysql-install-db.html
  * http://dev.mysql.com/doc/refman/5.5/en/default-privileges.html

To run as, for instance, user "mysql", you may need to `sudo`:
    sudo mysql_install_db ...options...

Start mysqld manually with:
    mysql.server start

    Note: if this fails, you probably forgot to run the first two steps up above

A "/etc/my.cnf" from another install may interfere with a Homebrew-built
server starting up correctly.

To connect:
    mysql -uroot

To launch on startup:
* if this is your first install:
    mkdir -p ~/Library/LaunchAgents
    cp /usr/local/Cellar/mysql/5.5.25a/homebrew.mxcl.mysql.plist ~/Library/LaunchAgents/
    launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist

* if this is an upgrade and you already have the homebrew.mxcl.mysql.plist loaded:
    launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
    cp /usr/local/Cellar/mysql/5.5.25a/homebrew.mxcl.mysql.plist ~/Library/LaunchAgents/
    launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist

You may also need to edit the plist to use the correct "UserName".

==> Summary
/usr/local/Cellar/mysql/5.5.25a: 6382 files, 222M, built in 84 seconds
{%endcodeblock%}

Set up db to run as your user account
{%codeblock%}
unset TMPDIR
mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp
{%endcodeblock%}

Start the server
{%codeblock%}
mysql.server start
{%endcodeblock%}

Secure the installation
{%codeblock%}
mysql_secure_installation
{%endcodeblock%}

Make sure to let mysql launch on startup
{%codeblock%}
mkdir -p ~/Library/LaunchAgents
cp /usr/local/Cellar/mysql/5.5.25a/homebrew.mxcl.mysql.plist ~/Library/LaunchAgents/
launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
{%endcodeblock%}

Make sure to check the plist to use the correct user
{%codeblock%}
vi ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
{%endcodeblock%}