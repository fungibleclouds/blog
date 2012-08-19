---
layout: post
title: "Computational Investing"
date: 2012-08-18 21:18
comments: true
categories: investing python portfoliomanagement
---
I just discovered an online course on Computational Investing that [Prof. Tucker Balch](http://www.cc.gatech.edu/~tucker/) from the [College of Computing](http://www.cc.gatech.edu/) at [Georgia Tech](http://www.gatech.edu/) is offering on [coursera](https://www.coursera.org/course/compinvesting1). It nicely blends my interests in the financial markets and computers so I immediately registered for it. The course has not started yet but for those interested in getting a headstart, here is a quick step-by-step on how I set my computer up with the [QuantSoftware ToolKit](http://wiki.quantsoftware.org/index.php)

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

Install homebrew and wget

	ruby <(curl -fsSkL raw.github.com/mxcl/homebrew/go)
	brew install wget

Create a quant virtualenv (*for use with QSTK*)

	mkvirtualenv quant
	cd ~/domains/quant

Install `numpy`
	
	pip install numpy

Install `gfortran` from ATT
	 
Download and install gfortran from [ATT Research](http://r.research.att.com/tools/). I haven't verified yet if this step is truly necessary. Moreover, I think it would be better to install `gfortran` via `homebrew`.

Install `scipy` from [source](https://github.com/scipy/scipy) as `pip install scipy` seems to fail

	mkdir ~/domains/quant/src
	cd ~/domains/quant/src
	git clone git://github.com/scipy/scipy.git
	cd scipy
	python setup.py install

Install `matplotlib` from [source](https://github.com/matplotlib/matplotlib) as `pip install matplotlib` seems to fail

	pip install -e git+https://github.com/matplotlib/matplotlib.git#egg=matplotlib

Install `python-dateutil`

	pip install python-dateutil
	
Install `pandas`
	
	pip install pandas
	
Install `epydoc`

	pip install epydoc
	
Install `distribute`

	pip install distribute
	
Install `pyqt`

	brew install pyqt # brew installed sip as sip is a dependency
	
Install `CVXopt` from [source](http://abel.ee.ucla.edu/cvxopt/index.html)
	
	cd ~/domains/quant/src
	wget http://abel.ee.ucla.edu/src/cvxopt-1.1.5.tar.gz
	tar zxvf cvxopt-1.1.5.tar.gz
	cd cvxopt-1.1.5/src
	python setup.py install

Install `QSTK`

	cd ~/domains/quant/
	mkdir QSTK
	cd QSTK
	svn checkout http://svn.quantsoftware.org/openquantsoftware/trunk .
	
Install `QSDATA` - *sample data from the stock market*

	wget http://www.quantsoftware.org/QSData.zip
	unzip QSData.zip

Configure the qstk specific `env` variables

	cp config.sh local.sh
	vi local.sh # edit the $QSDATA env var to point to $QS/QSData/
	vi local.sh # edit this to match path of QSTK and QSDATA
		$QS : This is the path to your installation (The location of the Bin, Example, Docs) folders.
		$QSDATA : This is where all the stock data will be.
	source local.sh
	
Test the `env` variables

	echo $QS # shows ~/domains/quant/QSTK
	echo $QSDATA # shows ~/domains/quant/QSTK/QSData
	
Install `readline` and `ipython` (both are optional)

	pip install readline
	pip install ipython
	
####Now you are ready to run the QSTK examples 

	cd $QS/Examples/DataAccess/
	python setupexample.py

The class is not started yet but here are the two recommended readings that I ordered already.

* [Active Portfolio Management: A Quantitative Approach for Producing Superior Returns and Controlling Risk](http://www.amazon.com/Active-Portfolio-Management-Quantitative-Controlling/dp/0070248826) by Richard Grinold, Ronald Kahn 

* [All About Hedge Funds: The Easy Way to Get Started](http://www.amazon.com/All-About-Hedge-Funds-Started/dp/0071393935) by Robert Jaeger

I am looking forward to applying the learnings from this class to my [personal portfolio](https://www.thinkorswim.com/tos/client/index.jsp).
