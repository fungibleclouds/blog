---
layout: post
title: "Computational Investing"
date: 2012-08-18 21:18
comments: true
categories: investing python portfoliomanagement
---
I just discovered an online course on Computational Investing that [Prof. Tucker Balch](http://www.cc.gatech.edu/~tucker/) from the [College of Computing](http://www.cc.gatech.edu/) at [Georgia Tech](http://www.gatech.edu/) is offering on [coursera](https://www.coursera.org/course/compinvesting1). It nicely blends my interests in the financial markets and computers so I immediately registered for it. The course has not started yet but for those interested in getting a headstart, here is a quick step-by-step on how I set my computer up with the [QuantSoftware ToolKit](http://wiki.quantsoftware.org/index.php)

####Getting the basics down

	ruby <(curl -fsSkL raw.github.com/mxcl/homebrew/go)
	brew install wget
	brew install pyqt # brew installed sip as sip is a dependency
	brew install gfortran
	brew install gtk
	brew install ghostscript
	brew install swig
	
 Use a virtual environment for use with QSTK *(so it wont mess up existing setup)* See my [other post](/blog/2012/08/17/python-virtualenv/) on setting up a virtualenv  and create a quant virtualenv

	mkvirtualenv quant
	cd ~/domains/quant

*The rest of the steps take place inside the newly created `quant` virtualenv.*

Install `numpy` from [source](https://github.com/numpy/numpy)
	
	pip install -e git+https://github.com/numpy/numpy.git#egg=numpy-dev

Install other dependencies via a requirements.txt file *created by `pip freeze > requirements.txt` from a working installation.*

	pip install -r requirements.txt
		
{% include_code PIP Requirements File lang:js requirements.txt %}

Install `statsmodels` from [source](https://github.com/statsmodels/statsmodels)
	
	pip install -e git+https://github.com/statsmodels/statsmodels.git#egg=statsmodels-dev
	
Install `CVXopt` from [source](http://abel.ee.ucla.edu/cvxopt/index.html) 

`pip install cvxopt` should work but seems there is a [bug](http://sourceforge.net/tracker/?func=detail&aid=3561044&group_id=66150&atid=513503) with `cvxopt.` 
	
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

	echo $QS # would show ~/domains/quant/QSTK
	echo $QSDATA # would show ~/domains/quant/QSTK/QSData
		
####Now you are ready to run the QSTK examples 

	ipython notebook --pylab inline # This will open your default browser http://localhost:8888
	
Click on new notebook to create a new tab with new empty notebook. In that new notebook, type this code segment to test your setup

	import numpy as np
	import pandas as pand
	import matplotlib.pyplot as plt
	from pylab import *
	x = np.random.randn(1000)
	plt.hist(x,100)
	plt.savefig('test.png',format='png')

Press SHIFT-ENTER to see something like this below.

{% img https://dl.dropbox.com/u/2093887/blog/pictures/randomplot.png %}	

The class is not started yet but here are the two recommended readings that I ordered already.

* [Active Portfolio Management: A Quantitative Approach for Producing Superior Returns and Controlling Risk](http://www.amazon.com/Active-Portfolio-Management-Quantitative-Controlling/dp/0070248826) by Richard Grinold, Ronald Kahn 

* [All About Hedge Funds: The Easy Way to Get Started](http://www.amazon.com/All-About-Hedge-Funds-Started/dp/0071393935) by Robert Jaeger

I am looking forward to applying the learnings from this class to my [personal portfolio](https://www.thinkorswim.com/tos/client/index.jsp).
