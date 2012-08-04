---
layout: post
title: "Hide unhide hidden files in Finder on a Mac"
date: 2011-10-10 20:17
comments: true
categories: productivity
---

If you can't see hidden files in OSX but want to, open up Terminal and type the following 2 lines:

{% codeblock %}
defaults write com.apple.finder AppleShowAllFiles TRUE
killall Finder
{% endcodeblock %}

To hide hidden files again, type:

{% codeblock %}
defaults write com.apple.finder AppleShowAllFiles FALSE
killall Finder
{% endcodeblock %}
