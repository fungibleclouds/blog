---
layout: post
title: "Run Pandora via Terminal"
date: 2012-09-22 13:17
comments: true
categories: music terminal
---

If you like [Pandora](http://www.pandora.com/) but rather flash and visual ads that go along with it, all you need is pianobar which you can install in one line. Just open terminal and type:


	brew install pianobar


Now you can run your flash-free Pandora player in your terminal. 

	➜  ~  pianobar
	Welcome to pianobar (2012.09.07)! Press ? for a list of commands.
	[?] Email: lvnilesh@yahoo.com
	[?] Password: 
	(i) Login... Ok.
	(i) Get stations... Ok.
	0)     Boston Radio
	1)     Guns N' Roses Radio
	2)     Kishore Kumar, Mohd. Rafi, Mukesh & Lata Mangeshkar Radio
	3)     Lata Mangeshkar Radio
	4)     Led Zeppelin Radio
	5) q   Michael Jackson Radio
	6)  Q  QuickMix
	7)     Super Freak Radio
	[?] Select station: 5
	|>  Station "Michael Jackson Radio" (116177894800507788)
	(i) Receiving new playlist... Ok.
	|>  "Wanna Be Startin' Somethin'" by "Michael Jackson" on "Thriller"
	|>  "Signed, Sealed, Delivered I'm Yours [Alternate Mix]" by "Stevie Wonder" on "The Complete Motown Singles: Volume 10: 1970"
	|>  "Freak" by "Chic" on "The Definitive Groove Collection: Chic"
	|>  "Brick House" by "The Commodores" on "Colour Collection"
	|>  "Thriller" by "Michael Jackson" on "Thriller"
	#   -05:34/05:59

###Updated with bonus: 

Also run [last.fm](http://last.fm) via terminal. Open terminal and type:

	brew install shell-fm

and create the file ~/.shell-fm/shell-fm.rc containing this.
	
	username = your-username
	password = your-password
	default-radio = lastfm://user/your-username/your-station-name
	
	#  for example: lastfm://user/lvnilesh/personal

and run

	➜  ~  shell-fm                
	Shell.FM v0.8, (C) 2006-2010 by Jonas Kramer
	Published under the terms of the GNU General Public License (GPL).

	Press ? for help.

	Receiving lvnilesh’s Library Radio.
	Now playing "Call Me Maybe" by Carly Rae Jepsen.
	-00:01

Enjoy!