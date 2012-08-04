---
layout: post
title: "Wake a Sleeping Machine From Your Network"
date: 2011-10-12 11:46
comments: true
published: true
categories: eco-friendly productivity
---
Most modern computers are capable of [Wake on LAN](http://en.wikipedia.org/wiki/Wake-on-LAN) which allows you to turn on a sleeping computer remotely by sending a "magic packet." Scheduled applications, nighly backup for example, use this feature. 

I use this feature to turn on my sleeping iMac when I am away from it but want to log on using ssh (I maintain one Ubuntu machine on the local network that is always running).

The magic packet format is very simple: it must include 6 times hexadecimal FF, followed by 16 times the target machine's MAC address.

Here is a Python script that will wake up your target machine remotely.

{% include_code wakeup.py %}

This script assumes that the target machine MAC address is 01-23-45-67-89-0a and that your local DHCP server issues an IP address of 192.168.2.109 to your target machine.

You can run this script from another machine on your local network, like so.
```
$ python wakeup.py
```

Got better ideas on waking up sleeping machines remotely when needed? Share below via comments.
