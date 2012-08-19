---
layout: post
title: "ZFS to the rescue"
date: 2012-08-13 05:58
comments: true
categories: ZFS Storage
---
This morning one of my harddisks `ada5p2` in the `tank` pool decided to become unavailable. Even though I store critical data on this pool, I have nothing really to worry about because this [ZFS](http://en.wikipedia.org/wiki/ZFS) pool is configured as `raidz2` - *a disk pool that can tolerate two simultaneous disk failures*.

	# zpool status -v tank
		pool: tank
		state: DEGRADED
		status: One or more devices could not be opened.  Sufficient replicas exist for the pool to continue functioning in a degraded state.
		action: Attach the missing device and online it using 'zpool online'. 
		see: http://www.sun.com/msg/ZFS-8000-2Q
		scrub: scrub in progress for 0h0m, 0.00% done, 73h11m to go
		config:
	 
			NAME        STATE     READ WRITE CKSUM
			tank        DEGRADED     0     0     0
			  raidz2    DEGRADED     0     0     0
				ada1p2  ONLINE       0     0     0
				ada2p2  ONLINE       0     0     0
				ada3p2  ONLINE       0     0     0
				ada4p2  ONLINE       0     0     0
				ada5p2  UNAVAIL      3 3.69K     0  cannot open

		errors: No known data errors
		
*Without shutting down my storage system*, I just yanked the SATA cable from that broken harddisk and [hot replaced](http://docs.oracle.com/cd/E19253-01/819-5461/gfgac/index.html) it with another of similar size. Now ZFS would resilver that replaced drive on its own in the next couple hours but I was essentially done without any downtime and without any data errors. [ZFS](http://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/filesystems-zfs.html) is nice indeed.

A [cron job](http://en.wikipedia.org/wiki/Cron) periodically scrubbing the zpools helps. ZFS has a built in scrub function that checks for errors and corrects them when possible. Running this task is pretty essential to prevent more errors that aren’t correctable. By default, ZFS doesn’t run this periodically, you have to tell it when to scrub. The easiest way to set up periodic scrubbing is to use *crontab*, a feature present in all UNIX systems for scheduling background tasks. Start the editing of root user's crontab by issuing the command `crontab -e` as `root`. The crontab is set up by a simple set of commands:

	* * * * * command to run
	- - - - -
	| | | | |
	| | | | +----- day of week (0-6) (Sunday is 0)
	| | | +------- month (1-12)
	| | +--------- day of month (1-31)
	| +----------- hour (0-23)
	+------------- min (0-59)

For example, I want my system to scrub my `tank` zpool on Sundays at 04:00 and my `twoteebee` zpool on Thursdays at 04:00. The specific commands that I put in my crontab are:

	0 4 * * 0 /sbin/zpool scrub tank
	0 4 * * 4 /sbin/zpool scrub twoteebee
	
