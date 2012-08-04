---
layout: post
title: "Juju: Cloud Magic Engine"
date: 2011-10-07 13:06
comments: true
published: false
categories: cloud
---
Ubuntu server is one of my preferred operating systems for deployment of applications in the cloud. The stability Ubuntu 10.04 LTS (Lucid Lynx) release provides has been phenomenal plus a long 5 year support window Ubuntu provides for LTS servers makes it especially well suited for business application deployment in the cloud. 

The next LTS server Ubuntu 12.04 LTS (Precise Pangolin) is scheduled for April 2012. Its precursor Ubuntu 11.10 Oneiric Ocelot release is scheduled for Oct 13 which will include Juju, a cloud services orchestration engine, which provides shareable, re-usable, and repeatable expressions of cloud management best practices. For example, with Juju, you can spin up a Hadoop deployment on a large number of nodes in a matter of few minutes.

- Data:
- 1.8ZB will be created and replicated in 2011
+ up 9x in the last 5 years
- more than 90% of this data is unstructured
- Enterprises have some liability for 80% of this data
- Enterprises will spend $4T on managing data in 2011

Apache Hadoop designed for:
* Volume - commodity hardware = open source software lower cost; increase capacity
* Velocity - Data ingest speed aided by append-only and schema-on-read design
* Variety - multiple tools to structure, process and access data

Hadoop Core
* HDFS
* MapReduce

Hadoop Ecosystem Components
* HBase
* Hive
* Pig
* Oozie
* Flume
* Sqoop
* ZooKeeper

Some questions emerge.
* What standards should all components follow?
* How can we ensure all components of the stack work together?
* How can we find the right version of each components?
* How can we make it easy to instal an additional component?

Enter Apache Bigtop
* Hadoop ecosystem-wide project, including:
* interoperability testing of components
* Packaging of compatible version of components
* Like a Fedora, Debian or CentOS for Hadoop ecosystem
* Releases are not a single artefact
* rather a set of interdependent, compatible components

Bigtop Components
* Hadoop - HDFS and MapReduce
* HBase - Realtime key value store
* Hive - Query Engine build on top of MapReduce
* Pig - Query Engine built on top of MapReduce
* Oozie - Workflow Engine
* Sqoop - Interop with SQL db
* Flume - for data ingest pipeline into 
* ZooKeeper - for coordination
* Whirr - for deployment in cloud
