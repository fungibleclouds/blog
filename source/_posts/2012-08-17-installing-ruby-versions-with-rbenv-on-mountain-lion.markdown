---
layout: post
title: "Installing multiple versions of Ruby"
date: 2012-08-17 10:24
comments: true
categories: 10.8 ree mountainlion osx ruby
---
Install XCode command-line tools. Available from the Preferences > Download panel in XCode, or as a separate download from the Apple Developer site.

Install gcc-4.2. Ruby versions before 1.9 (such as 1.8.7 or REE) do not play well with Apple's LLVM compiler, so you'll need to install the old gcc-4.2 compiler. It's available in the homebrew homebrew/dupes repository.

{%codeblock%}
brew tap homebrew/dupes
brew install apple-gcc42
{%endcodeblock%}

Install xquartz. The OS X upgrade will also remove your old X11.app installation, so go grab xquartz from http://xquartz.macosforge.org/landing/ and install it (you'll need v2.7.2 or later for Mountain Lion).

Install Ruby 1.9. This one is simple.
{%codeblock%}
rbenv install 1.9.3-p194
{%endcodeblock%}

Install Ruby 1.8.7. Remember to add the path to the xquartz X11 includes in CPPFLAGS. Here I'm using rbenv, but the same environment variables should work for rvm.

{%codeblock%}
CPPFLAGS=-I/opt/X11/include rbenv install 1.8.7-p370
{%endcodeblock%}		

Install ree. Remember to add the path to the xquartz X11 includes in CPPFLAGS and the path to gcc-42 in CC. Here I'm using rbenv, but the same environment variables should work for rvm.

{%codeblock%}
CPPFLAGS=-I/opt/X11/include CC=/usr/local/bin/gcc-4.2 rbenv install ree-1.8.7-2012.02
{%endcodeblock%}

Enjoy your new Ruby versions

{%codeblock%}
rbenv versions
{%endcodeblock%}
