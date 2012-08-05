---
layout: post
title: "Improving blog performance using AWS S3 + CloudFront"
date: 2012-08-03 17:14
comments: true
categories: cloud
---
{%img http://dl.dropbox.com/u/2093887/blog/pictures/CloudFront%20S3.png%}
When I first switched over to blogging using Octopress, I loaded it up on heroku via git but I was not super satisfied by the site's performance for world wide audience. It took me a bit of exploring for a good but cost effective way to improve performance using CDN so here is a writeup explaining my setup that might help others.

If you have a blog but haven’t heard of Octopress, you should check it out. It’s great for anyone who likes writing in the text editor of their choice (I currently like IA Writer, and Writing Kit) instead of some web interface, wants to store the work in git, and is comfortable running a few Terminal commands.

### Why AWS S3 and CloudFront?
I initially started out hosting my blog using a single Web Dyno, which is a free service offered by heroku for hosting my Octopress blog stored in git. The price was certainly right, but Heroku experienced a bit of downtime over the course of the life of my blog on Heroku and I feel strongly about uptime.

An alternative is using Amazon S3, Amazon’s cloud file storage service. Amazon lets you host a static website on S3 with your own domain name. You can also easily use Amazon CloudFront with S3. CloudFront is a CDN (content distribution network) that serves your content from a worldwide server network and helps to make your website faster.

### Setting up S3
If you’ve never used Amazon Web Services before, it can be a little confusing to get started. First, you need to sign up for an AWS account. When you have your account, log into the AWS Management Console and head to the S3 tab. Then:

* Create a bucket called blog.myowndomain.com. You can not use myowndomain.com so use a subdomain like www or blog.

* Under the properties for this bucket, you’ll need to go to the Website tab, check the box to enable static web hosting, and set your index and error documents. Your index document should probably be index.html. Your error document could be 404.html (an HTML page for file not found (404) errors). Make a note of your endpoint *(http://blog.fungibleclouds.com.s3-website-us-east-1.amazonaws.com/)*. You’ll need it to create custom origin CloudFront distribution.
* Create a bucket policy under permissions. Here is my bucket policy. <script src="https://gist.github.com/3252025.js"> </script>

### Setting CloudFront
In AWS Console, go to the CloudFront tab, and create a new Distribution for the S3 website end point as custom origin. This link on [custom origin](http://trac.cyberduck.ch/wiki/help/en/howto/cloudfront#CustomOriginHTTPHTTPSDistributions) helps. This will mirror your S3 bucket on CloudFront, for example, *(http://d2h7g34rdqpc09.cloudfront.net/index.html)* shows the home page of my website exactly as it appears on S3.

CloudFront will cache the contents of your S3 bucket for up to 24 hours. This cache is created from S3 the first time someone hits an asset under your CloudFront URL. This means that CloudFront won’t necessarily reflect changes on S3 immediately. You can manually invalidate/expire objects in CloudFront, but it’s easier to just not use it for anything that will change frequently.

### Setting up your DNS
You’ll need to create a DNS CNAME alias record to use your own domain with CloudFront that mirrors your S3 bucket. The way you do this depends on your DNS provider (I use [Zerigo](http://www.zerigo.com), which is cheap, reliable, and easy to use). You need to create a CNAME pointing blog.myowndomain.com to your CloudFront endpoint.

After propagation, your DNS results should look something like this.

{% codeblock %}
nilesh$ dig blog.fungibleclouds.com

; <<>> DiG 9.8.1-P1 <<>> blog.fungibleclouds.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 13827
;; flags: qr rd ra; QUERY: 1, ANSWER: 9, AUTHORITY: 13, ADDITIONAL: 0

;; QUESTION SECTION:
;blog.fungibleclouds.com.	IN	A

;; ANSWER SECTION:
blog.fungibleclouds.com. 900	IN	CNAME	d2h7g34rdqpc09.cloudfront.net.
d2h7g34rdqpc09.cloudfront.net. 59 IN	A	205.251.215.16
d2h7g34rdqpc09.cloudfront.net. 59 IN	A	205.251.215.67
d2h7g34rdqpc09.cloudfront.net. 59 IN	A	205.251.215.91
d2h7g34rdqpc09.cloudfront.net. 59 IN	A	205.251.215.140
d2h7g34rdqpc09.cloudfront.net. 59 IN	A	205.251.215.174
d2h7g34rdqpc09.cloudfront.net. 59 IN	A	205.251.215.176
d2h7g34rdqpc09.cloudfront.net. 59 IN	A	205.251.215.226
d2h7g34rdqpc09.cloudfront.net. 59 IN	A	205.251.215.2

;; AUTHORITY SECTION:
.			491338	IN	NS	j.root-servers.net.
.			491338	IN	NS	a.root-servers.net.
.			491338	IN	NS	g.root-servers.net.
.			491338	IN	NS	k.root-servers.net.
.			491338	IN	NS	c.root-servers.net.
.			491338	IN	NS	f.root-servers.net.
.			491338	IN	NS	e.root-servers.net.
.			491338	IN	NS	h.root-servers.net.
.			491338	IN	NS	d.root-servers.net.
.			491338	IN	NS	l.root-servers.net.
.			491338	IN	NS	i.root-servers.net.
.			491338	IN	NS	b.root-servers.net.
.			491338	IN	NS	m.root-servers.net.

;; Query time: 155 msec
;; SERVER: 127.0.0.1#53(127.0.0.1)
;; WHEN: Fri Aug  3 21:15:39 2012
;; MSG SIZE  rcvd: 420

nilesh$ 
{% endcodeblock %}

### Pushing your Octopress changes over to S3
This action is fairly simple. First you edit your posts you store in source/_posts. I currently prefer iA Writer so I keep a little executable script I label as ia to invoke it from the terminal.
{% codeblock %}
#!/bin/bash
for FILE in "$@"
do
	open -a "iA Writer" "$FILE"
done;
{% endcodeblock %}

Then you generate static HTML for your site.
{% codeblock %}
$ rake generate
{% endcodeblock %}

and finally you push your incremental updates over to S3 using [s3cmd](http://s3tools.org) in rsync like fashion
{% codeblock %}
$ s3cmd sync --reduced-redundancy --recursive --exclude "*.tiff"  --exclude "*.plist" --delete-removed ~/blog.fungibleclouds.com/public/* s3://blog.fungibleclouds.com/ --verbose
{% endcodeblock %}
