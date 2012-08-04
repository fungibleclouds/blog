---
layout: post
title: "Get colorful directory listing in terminal on a Mac"
date: 2011-10-10 20:17
comments: true
categories: productivity
---

Terminal looks monochromatic by default on a Mac like this screenshot below.

{% img http://dl.dropbox.com/u/2093887/blog/pictures/lscolors/before.jpg %}

Want to get ls colors on terminal on a mac like you may have seen in Ubuntu and some other linux distributions? Just append these two lines to your .bash_profile

{% codeblock %}
export CLICOLOR=1
export LSCOLORS=ExFxCxDxbxegedabagacad
{% endcodeblock %}

Make sure to restart your SHELL after which the terminal will show ls colors like below.

{% img http://dl.dropbox.com/u/2093887/blog/pictures/lscolors/after.jpg %}

Got your productivity enhancing tips? Share via comments below.
