---
layout: post
title: "Credentials as env variables"
date: 2012-09-23 11:46
comments: true
categories: python boto
---
AWS credentials can either be passed in line (not ideal as your code is clutted with secret info) or it can be passed via environment variables (preferred method). The AWS tools require you to save your AWS account’s main `access key id` and `secret access key` in a specific way. 

Create this credentials master file `$HOME/.credentials-master.txt` in the following format (replacing the values with your own credentials):

{% include_code Credentials Master File lang:js .credentials-master.txt %}

*Note*: The above is the sample content of `.credentials-master.txt` file you are creating, and not shell commands to run.

Protect the above file and set an environment variable to tell AWS tools where to find it:

	export AWS_CREDENTIAL_FILE=$HOME/.credentials-master.txt
	chmod 600 $AWS_CREDENTIAL_FILE

We can now use the command line tools to create and manage the cloud.


##Using ipython

[iPython](http://ipython.org/) is a beautiful interactive shell for python which you can easily install in a [virtualenv](/blog/2012/08/17/python-virtualenv/). Just type

	pip install tornado pyzmq ipython

and then run

	ipython notebook --pylab inline

This would open `http://127.0.0.1:8888/` in a browser window where you can run python interactively. According to [iPython notebook installation](http://ipython.org/ipython-doc/dev/install/install.html#installnotebook), MathJax is not installed by default which can be installed with these steps.

	from IPython.external.mathjax import install_mathjax
	install_mathjax()