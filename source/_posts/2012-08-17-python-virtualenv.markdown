---
layout: post
title: "python virtualenv"
date: 2012-08-17 13:58
comments: true
categories: python virtualenv
---
####Prepare a virtual environment *(so it wont mess up existing setup)*

	sudo easy_install pip
	sudo pip install virtualenv virtualenvwrapper
	mkdir domains # create a directory to store different virtual environments

Create a temporary text file (say `~/appendthis`) with below text

	export WORKON_HOME=$HOME/domains
	source /usr/local/bin/virtualenvwrapper.sh
	export PIP_VIRTUALENV_BASE=$

Append that temp file to `~/.zshenv` (or `.profile` or `.bashrc` depending on your shell)

	cat ~/appendthis >> ~/.zshenv

Exit current shell and start terminal again to see something like this show up:

	Linux quant 2.6.32-27-generic #49-Ubuntu SMP Thu Dec 2 00:51:09 UTC 2010 x86_64 GNU/Linux Ubuntu 10.04.1 LTS

	Welcome to Ubuntu!
	* Documentation:  https://help.ubuntu.com/
	Last login: Thu Dec 23 14:35:06 2010 from imac.workgroup
	virtualenvwrapper.user_scripts Creating /home/nilesh/domains/initialize
	virtualenvwrapper.user_scripts Creating /home/nilesh/domains/premkvirtualenv
	virtualenvwrapper.user_scripts Creating /home/nilesh/domains/postmkvirtualenv
	virtualenvwrapper.user_scripts Creating /home/nilesh/domains/prermvirtualenv
	virtualenvwrapper.user_scripts Creating /home/nilesh/domains/postrmvirtualenv
	virtualenvwrapper.user_scripts Creating /home/nilesh/domains/predeactivate
	virtualenvwrapper.user_scripts Creating /home/nilesh/domains/postdeactivate
	virtualenvwrapper.user_scripts Creating /home/nilesh/domains/preactivate
	virtualenvwrapper.user_scripts Creating /home/nilesh/domains/postactivate
	virtualenvwrapper.user_scripts Creating /home/nilesh/domains/get_env_details

Now you can create any number of python virtual environments. For example, I create myfirstenv

	mkvirtualenv myfirstenv # create my first virtual environment named myfirstenv
	pip install BLAH # install BLAH
	deactivate # deactivate that virtualenv
	rmvirtualenv myfirstenv # remove myfirstenv

To work with virtualenv again, simply type:

	workon myfirstenv
	cd ~/domains/myfirstenv

Wrappers: Virtualenv provides several useful wrappers that can be used as shortcuts

	mkvirtualenv (create a new virtualenv)
	rmvirtualenv (remove an existing virtualenv)
	workon (change the current virtualenv)
	add2virtualenv (add external packages in a .pth file to current virtualenv)
	cdsitepackages (cd into the site-packages directory of current virtualenv)
	cdvirtualenv (cd into the root of the current virtualenv)
	deactivate (deactivate virtualenv, which calls several hooks)

Hooks: One of the coolest things about virtualenvwrapper is the ability to provide hooks when an event occurs. Hook files can be placed in `ENV/bin/` and are simply plain-text files with shell commands. virtualenvwrapper provides the following hooks:

	postmkvirtualenv
	prermvirtualenv
	postrmvirtualenv
	postactivate
	predeactivate
	postdeactivate

When you are done with that virtualenv, you can just type

	rmvirtualenv myfirstenv # this will destroy that virtualenv named `myfirstenv` under ~/domains
