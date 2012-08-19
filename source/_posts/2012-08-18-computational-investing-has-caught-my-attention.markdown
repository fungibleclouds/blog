---
layout: post
title: "Computational Investing"
date: 2012-08-18 21:18
comments: true
categories: Investing Computing python
---
I just discovered an online course on Computational Investing that recently got published on [coursera](https://www.coursera.org/course/compinvesting1). [Prof. Tucker Balch](http://www.cc.gatech.edu/~tucker/) from the College of Computing at [Georgia Tech](http://www.cc.gatech.edu/) is offering this course. It nicely blends my interests in the financial markets and computers so I immediately registered for it. The course has not started yet but for those interested in getting a headstart

Here is a quick step-by-step to setup your computer with the [QuantSoftware ToolKit](http://wiki.quantsoftware.org/index.php)

###Prepare a Virtual Environment Shell to run python

	sudo easy_install pip
	sudo pip install virtualenv virtualenvwrapper
	mkdir domains

####Create a text file vi ~/appendthisto.bashrc with below text

	export WORKON_HOME=$HOME/domains
	source /usr/local/bin/virtualenvwrapper.sh
	export PIP_VIRTUALENV_BASE=$

####and append the contents of that file to ~/.bashrc or .profile or .zshenv (depending on your shell)

	cd ~/
	cat appendthisto.bashrc >> ~/.bashrc

####exit current shell and login again to see below:

	Linux micro 2.6.32-27-generic #49-Ubuntu SMP Thu Dec 2 00:51:09 UTC 2010 x86_64 GNU/Linux Ubuntu 10.04.1 LTS

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

####Now you can create any number of python virtual environments. For example, I create myfirstenv

	mkvirtualenv myfirstenv # I create my first virtual environment named myfirstenv
	pip install BLAH # here I install BLAH
	deactivate # here is deactivate that virtualenv
	rmvirtualenv myfirstenv # here is remove myfirstenv

####To work with virtualenv again, simply type:

	workon myfirstenv
	cd ~/domains/myfirstenv

####Wrappers

Virtualenv provides several useful wrappers that can be used as shortcuts

	mkvirtualenv (create a new virtualenv)
	rmvirtualenv (remove an existing virtualenv)
	workon (change the current virtualenv)
	add2virtualenv (add external packages in a .pth file to current virtualenv)
	cdsitepackages (cd into the site-packages directory of current virtualenv)
	cdvirtualenv (cd into the root of the current virtualenv)
	deactivate (deactivate virtualenv, which calls several hooks)

####Hooks

One of the coolest things about virtualenvwrapper is the ability to provide hooks when an event occurs. Hook files can be placed in ENV/bin/ and are simply plain-text files with shell commands. virtualenvwrapper provides the following hooks:

	postmkvirtualenv
	prermvirtualenv
	postrmvirtualenv
	postactivate
	predeactivate
	postdeactivate

### Install homebrew and wget

	ruby <(curl -fsSkL raw.github.com/mxcl/homebrew/go)
	brew install wget
	
###Create a quant virtualenv (for use with QSTK)

	mkvirtualenv quant
	cd ~/domains/quant

####Install numpy
	
	pip install numpy

####Install gfortran from ATT
	 
	Download and install gfortran from {ATT Research](http://r.research.att.com/tools/)

####Install scipy from https://github.com/scipy/scipy
	
	mkdir src
	cd src
	git clone git://github.com/scipy/scipy.git
	cd scipy
	python setup.py install

####Install matplotlib from https://github.com/matplotlib/matplotlib

	pip install -e git+https://github.com/matplotlib/matplotlib.git#egg=matplotlib

####Install python-dateutil

	pip install python-dateutil
	
####Install pandas
	
	pip install pandas
	
####Install epydoc

	pip install epydoc
	
####Install distribute

	pip install distribute
	
####Install pyqt

	brew install pyqt # this got sip as well
	
####Install CVXopt
	
	cd src
	tar zxvf cvxopt-1.1.5.tar.gz
	cd cvxopt-1.1.5/src
	python setup.py install

####Install QSTK

	cd domains/quant/
	mkdir QSTK
	cd QSTK
	svn checkout http://svn.quantsoftware.org/openquantsoftware/trunk .
	
####Install QSDATA
	wget http://www.quantsoftware.org/QSData.zip
	unzip QSData.zip
####Configure the env variables
	cp config.sh local.sh
	vi local.sh # edit the $QSDATA env var to point to $QS/QSData/
	vi local.sh # edit this to match path of QSTK and QSDATA
		$QS : This is the path to your installation (The location of the Bin, Example, Docs) folders.
		$QSDATA : This is where all the stock data will be.
	source local.sh
	
####Test the env variables
	echo $QS # shows ~/domains/quant/QSTK
	echo $QSDATA # shows ~/domains/quant/QSTK/QSData
	
####Install ipython and readline	

	pip install readline
	pip install ipython
	
####Now you are ready to run the QSTK examples 

	cd $QS/Examples/DataAccess/
	python setupexample.py

