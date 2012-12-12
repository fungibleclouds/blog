---
layout: post
title: "Using Chef to deploy cloud applications"
date: 2012-12-09 22:00
comments: true
categories: 
---
[Chef](http://github.com/opscode/chef) is a popular [Apache licensed](http://www.apache.org/licenses) open source configuration management and automation tool for the cloud. It drives three core ideas in the cloud computing industry.

### Fungibility: 
Chef routinizes the repeatable steps in cloud operations management and it does that in a way that is almost agnostic to the underlying cloud provider. Chef thus helps make applications almost agnostic to the underlying machines.

**_Routinizing the repeatable_** is key to successful operations management and is described in detail in a paper on [Integrated Operations](http://deepblue.lib.umich.edu/bitstream/2027.42/71915/1/j.1937-5956.1998.tb00443.x.pdf) by [Prof. William Lovejoy](http://www.bus.umich.edu/facultybios/facultybio.asp?id=000233395) of [The University of Michigan Business School, Ann Arbor](http://www.bus.umich.edu) and I quote...

_"{% pullquote %} {"If some task is to be repeated many times, it makes sense to find out the best way to perform the task and then require its execution according to that best practice."} This means that in stable task environments, stable work routines and policies will be generated over time, and this is efficient. This derives from March and Simon’s (1958) model of organizational learning. The consequences for this are that one will want to consider the relationship between efficiency and discretion allowed workers in a stable environment. {% endpullquote %}"_ 

Using Chef to manage cloud applications makes cloud computer from a provider, say [AWS EC2](http://aws.amazon.com/ec2), fairly easily substituted by cloud computers from another provider, say [HP Cloud](https://www.hpcloud.com/products/cloud-compute).

As my friend [Kevin Jackson](https://twitter.com/GovCloud) describes, Cloud computing has several [economic benefits](http://www.forbes.com/sites/kevinjackson/2011/09/17/the-economic-benefit-of-cloud-computing), however, cloud computing would become even more economical if cloud computers were [fungibile](http://en.wikipedia.org/wiki/Fungibility), meaning, a cloud machine from provider X would be practically no different than another cloud machine from provider Y. Fungibility would make cloud computers easily substitutable driving the price further down by increasing the competition and reducing the differention between providers of cloud computers. Fungibility, by the way, is not a property of [eukaryotic organisms](http://en.wikipedia.org/wiki/Fungus).

### Idempotence:

Chef operation (`sudo chef-client`) is **idempotent**, repeat runs will produce the exact same resulting machine configuration as the initial run did. [Idempotence](http://en.wikipedia.org/wiki/Idempotence) is the property of certain operations in mathematics and computer science, that they can be applied multiple times without changing the result beyond the initial application. The term was introduced by [Benjamin Peirce](http://en.wikipedia.org/wiki/Benjamin_Peirce) in the context of elements of an algebra that remain invariant when raised to a positive integer power, and literally means _the quality of having_ the same power, from idem + potence (same + power). 

Idempotent operations enables consistently reproducible cloud environments for development and production use. It helps bring order and reduce chaos in business operations. 

### Embryos and DNA Injections
Ok, I admit, this is going to be an incorrect analogy from biological science perspective but it does seem to work for some people as an crude example to explain the logic. What you get to accomplish is to give life to, say a giraffe (*Giraffa camelopardalis*), a cow (*Bos primigenius*), a leopard (*Panthera pardus*), or a person (*Homo sapiens*), based on the DNA you inject into an embryo. On similar lines, you create a web server running [nginx](http://nginx.org) with a specific configuration, or a proxy running [HAProxy](http://haproxy.1wt.eu), or a database master server running [PostgreSQL](http://www.postgresql.org) or whatever you need, by asking Chef to run an appropriate set of cookbooks on top of a cloud machine running just enough OS or [jeOS](http://en.wikipedia.org/wiki/Just_enough_operating_system) *(pronounced as [juice](http://blogs.vmware.com/console/2007/07/get-juiced.html) or jüs) *.

Chef helps spin up machines just the way you want with a specific set of software and specific configuration by building up from scratch right from bare metal machines loaded with just enough OS.

### Putting these concepts to work
Let's see in practise how these core concepts pan out in reality. This is best illustrated in form of a hands on exercise of creating an infrastructure in the cloud where we will have the production environment running first on a single server instance which is useful for rapid prototyping of apps while sharing a single machine among multiple applications to minimize cost. Once you’re comfortable with this basic all-in-one configuration, it’s relatively simple to scale it out, separating the various roles onto multiple machine instances.
move 
I must caution you that this is a fairly elaborate setup that would be needed on your linux/unix workstation but fortunately it’s all pretty straightforward, and there’s a lot of good documentation available on the internet.

#### Tools we will use

* A macintosh used as your workstation
* [Homebrew](http://mxcl.github.com/homebrew/)
* [Git](http://git-scm.com) - a distributed version control system
* [Chef](https://github.com/opscode/chef)
* [Chef cookbooks](https://github.com/opscode-cookbooks) from the community
* Access to a [Chef server](https://github.com/opscode-cookbooks/chef-server) that you may run on your own - or you can use the [hosted service](http://www.opscode.com/hosted-chef/) Opscode provides free for up to 5 nodes.
* Accounts with at least two cloud compute providers. I will illustrate the concept working across [Amazon Web Services EC2](http://aws.amazon.com//ec2) and [HP Cloud Compute](https://www.hpcloud.com/products/cloud-compute) cloud but you are free to experiment with other cloud providers which should also work using similar concepts.

#### Setup homebrew, git, chef, librarian, vagrant, ec2, hpcloud

	ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"
	brew install git
	gem install chef
	gem install librarian
	gem install vagrant
	vagrant box add precise64 http://files.vagrantup.com/precise64.box # latest Ubuntu LTS 12.04 for vagrant
	gem install knife-ec2
	gem install knife-hp
	
#### Setup your workstation to connect with your Chef server
Follow the [Chef Fast Start Guide](http://wiki.opscode.com/display/chef/Fast+Start+Guide) to set up your workstation. You need to go through about half that guide up to step 4. Stop there as you don't need to configure the workstation as a client. In our case, the chef clients will run on vagrant, ec2, hpcloud and other cloud providers you select instead of on your workstation.

If you follow that guide, it will create a `~/chef-repo/.chef/` folder with three files - `knife.rb`, `validation.pem` and `username.pem`. You need to move that `.chef` folder and those three files and to `~/.chef/` which lets you execute `knife` commands from anywhere on the workstation. 

My `knife.rb` looks something like this. Please note that I am using my own chef server - not opscode hosted chef - so make sure to customize your `knife.rb` file to properly connect with your Chef server. 

{% include_code knife.example.rb %}

* line 4 - your `username` on chef server
* line 5 - your `pem` file 
* line 6 - your `organization` name
* line 7 - your organizational `pem` file
* line 8 - `url:port` for your chef server

#### Create a new folder to work on

    mkdir -p ~/fungibility
	cd ~/fungibility
	git init
	
#### Gather community cookbooks

We will use `librarian` to gather the required cookbooks from the Chef community. Download this `Cheffile` to your `~/fungibility` folder. This `~/fungibility/Cheffile` will guide `librarian` what to bring down to the workstation.

{% include_code Cheffile lang:ruby %}

You can customize this Cheffile depending on your infrastructure needs. Libraian will download these specified cookbooks in `$PWD/cookbooks` and will also create a `$PWD/tmp` folder. You can put both these subfolders in your `.gitignore` file so as to not clutter your git repo.

    cd ~/fungibility
	librarian-chef install
	echo cookbooks >> .gitignore
	echo tmp >> .gitignore
    git add .
	git commit -m "initial commit"

#### Create a place for your custom cookbooks

Create a `site-cookbooks` sub-folder to store any custom cookbooks or customization to community cookbooks.

    cd ~/fungibility
	mkdir -p ~/fungibility/site-cookbooks
	touch site-cookbooks/readme.md
	echo "store custom cookbooks in here" >> site-cookbooks/readme.md
	git add .
	git commit -m "added a place for custom cookbooks"

#### Upload cookbooks from your workstation to the Chef server

    knife cookbook upload -a -o ./cookbooks	
    knife cookbook upload -a -o ./site-cookbooks

and here is a `BE CAREFUL: nuke all cookbooks` command just in case you need to start from fresh.

    knife cookbook bulk delete -y '.*'

#### Create Chef environments for development, test, and production

Your development, test, and production environments may differ, for example, the development environment might include debugging tools, which may not be installed in production. Chef lets you define different environments and assign a node to a particular environment. Let's create a `dev`, a `stage` and a `prod` environment which we can customize and fine tune later. 

Create `environments/dev.rb`, with the following contents:

    name "dev"
    description "The development environment"

Create `environments/stage.rb`, with the following contents:

    name "stage"
    description "The staging environment"

Create `environments/prod.rb`, with the following contents:

    name "prod"
    description "The production environment"

Commit the environment files to version control:

    git add environments
    git commit -m 'Add development, staging, and production environments.'

Upload the environments to the Chef server:

    cd ~/fungibility
	knife environment from file environments/dev.rb
    knife environment from file environments/stage.rb
    knife environment from file environments/prod.rb

#### Create Chef roles for webserver and database

Chef [roles](http://docs.opscode.com/essentials_roles.html) are a way to define certain patterns and processes that exist across nodes in a Chef organization as belonging to a single job function. It helps you define a group of recipes and attributes that should be applied to all nodes that perform a particular function. 

Lets us start creating a `base` role that would apply to all nodes, a `webserver` role, and a `db_master` role for the master database.

Create `roles/base.rb` containing the following:

	name "base"
	description "Base role applied to all nodes."
	
	run_list(
	  "recipe[apt]",
	  "recipe[git]",
	  "recipe[build-essential]",
	  "recipe[sudo]",
	  "recipe[users::sysadmins]",
	  "recipe[vim]"
	)
	
	override_attributes(
	  :authorization => {
	    :sudo => {
	      :users => ["ubuntu", "vagrant"],
	      :passwordless => true
	    }
	  }
	)

The `run_list` method defines a list of recipes to be applied to nodes in the `base` role. The `override_attributes` method overrides the default attributes used by community recipes. for example, this will overriding attributes used by the `sudo` cookbook so the `vagrant` and `ubuntu` users can run sudo without manually entering a password.

Create `roles/webserver.rb` containing the following:

	name "webserver"
	description "Web server role"
	
	all_env = [ 
	  "role[base]",
	  "recipe[php]",
	  "recipe[php::module_mysql]",
	  "recipe[apache2]",
	  "recipe[apache2::mod_php5]",
	  "recipe[apache2::mod_rewrite]",
	]

	run_list(all_env)

	env_run_lists(
	  "_default" => all_env, 
	  
	  #"dev" => all_env + ["recipe[php:module_xdebug]"],
	  "dev" => all_env,
	  
	  "prod" => all_env, 
	)
	
The `env_run_list` method in this `webserver` role defines different run lists for different environments. `all_env` array defines a common run list for all environments and is appended with additional run list item `php:module_xdebug` unique to `dev` environment in this case. 

Create `roles/db_master.rb` containing the following:

	name "db_master"
	description "Master database server"

	all_env = [
	  "role[base]", 
	  "recipe[mysql::server]"
	] 

	run_list(all_env)

	env_run_lists(
	  "_default" => all_env,
	  "prod" => all_env,
	  "dev" => all_env,
	)

The `all_env` array again defines a common run list for all environments. 

Commit these three roles, `base`, `webserver`, and `db_master` created under the `roles` subfolder. 

	git add roles
	git commit -m "add roles for base, webserver and db_master"

Update the roles in Chef Server

	knife role list # list all roles
	knife role delete `rolename` # to delete any stale role you may not need
	
	knife role from file roles/base.rb
	knife role from file roles/webserver.rb
	knife role from file roles/db_master.rb

####Set up a sysadmin user account

You need a user account created with sysadmin privileges on every node. You accomplish that by defining a data bag for the users cookbook, with attributes describing your credentials. 

It is best to use your existing user credentials from your workstation. Look for your public key under `~/.ssh` for a file named `id_dsa.pub` or `id_rsa.pub` or similar. That is your public key for your user account `$USER` on your workstation. Create a `public/private keypair` if you don't find any by executing these commands.

	echo "Checking for SSH key, generating one if it doesn't exist ..."
	[[ -f ~/.ssh/id_dsa.pub ]] || ssh-keygen -t dsa -C your@email.address

	echo "Copying public key to your clipboard so you can paste it whereever you like ..."
	[[ -f ~/.ssh/id_dsa.pub ]] && cat ~/.ssh/id_dsa.pub | pbcopy

Then create a new `data bag` file named after the user you want to create:

	mkdir -p data_bags/users
	vi data_bags/users/$USER.json

Edit below and paste your `public key` as one long string into the `ssh_keys` segment below and add this to the $USER.json file.
Remeber to replace `nilesh` with your `username` on your workstation. 

	{
	    "id": "nilesh",
	    "ssh_keys": "ssh-dss AAAAB3NzaC1kc3MAAACBANcunES89sbKlIhrtkpnECp7Z4a+BlJHZTHYjBAo/Itw2R4WmuXhbQiEcYdiYR0tZjKmIXzzG5M5wWIzpmvuOaBxThVMKk8Irgu0bzi9eNY/MD+EDTNRhzry8q/IJeh8jDRfSB2exdcMcFAjmiVdKJd5bbql5NkU9uZaxGhV2W8XAAAAFQCVxO/iejN6s/ToaJWfV8IEFaJiqwAAAIAHl3vQcjQ40G+ZLoj8S73fU7/XhX8ushb3fP4ERCFUm54mvkkezUXJGupUgEihZuPNHWZdvjouzD7H1HMf6xLaR/umjzBX3sNhKFwA0I1gFBsxnHEu3QW0JV9ObJdmfz70lm9/y8Cj96T+ErkgRKd7dW7XWeF125cR9yPWmPWsZwAAAIEAvXo9aoAtX9ZS/Z9WmNcdP2IH4/blOnLr8wMDk+r4hUd7nExWFF7ckDwOl5Wlm1iagvUHzkjRHQjyPX9uEs3WAxm7kk6ofnBiFYzfNAGemDgN1D5FkpTeg/cbkYohpr9Zyl9m1N5hV0jBW5faoh/O0KmFInLVi7yIrPHQNjGv/9o= your@email.address",
	    "groups": [ "sysadmin", "dba", "devops" ],
	    "uid": 2001,
	    "shell": "\/bin\/bash"
	}

Commit the data bag file to version control:

	git add data_bags
	git commit -m 'Add sysadmin user data bag item.'

Upload the data bag to the Chef server:

	knife data bag list # to list out existing data bag items
	knife data bad delete `itemname` # to delete any stale data bag item you may want to get rid of
	
	knife data bag create users
	knife data bag from file users users data_bags/users/$USER.json 

#### Create an encrypted data bag for passwords and other secrets

Use an encrypted data bag to store secrets like passwords and encryption keys.

Create an encryption key:

	openssl rand -base64 512 | tr -d '\r\n' > ~/.chef/encrypted_data_bag_secret
	chmod 400 ~/.chef/encrypted_data_bag_secret

Add this line to `~/.chef/knife.rb` which would copy the encryption key to Chef clients so they can use it for decryption.

	encrypted_data_bag_secret "#{current_dir}/encrypted_data_bag_secret"

Set the `$EDITOR` environment variable to `vi` by adding `export EDITOR=vi` to `~/.bash_profile` or `~/.zshenv`). The `knife data bag` command will launch this editor and allow you to edit the encrypted data bag contents. Create a new encrypted data bag item for storing MySQL passwords:

    knife data bag create --secret-file ~/.chef/encrypted_data_bag_secret secrets mysql

Enter this into vi when it opens and make sure to select better passwords that these:

	{
	  "id": "mysql",
	  
	  "dev": {
	    "root": "dev-my-root-password",
	    "repl": "dev-my-replication-password",
	    "debian": "dev-my-debian-password"
	  },
	  	  
	  "prod": {
	    "root": "secret-root-password",
	    "repl": "secret-replication-user-password",
	    "debian": "secret-debian-password"
	  }
	}

This would encrypt, set passwords for the `dev` and the `prod` environment and upload to the Chef server. To save the encrypted data bag locally, download that into a file and commit to version control in JSON format.

	mkdir -p data_bags/secrets
	knife data bag show secrets mysql -Fj > data_bags/secrets/mysql.json
	
	cat data_bags/secrets/mysql.json # you will see the encypted version of mysql data bag item
	{
	  "id": "mysql",
	  "dev": "vLb86kC71FK6Z860ru/5Nkz3oKTOu/+4fPY2ics3h82mfiZEZTS3KR3QF8LV\nORwCikcK32ahjpwvgYVo3IexpDRh3tyPKWs3tlup7m7dsiDs9TrKbYsL3Ze+\n/9N6cQweV2+MbJmJ7+qqRjmyxEECbg==\n",
	  "prod": "/2tmCI0ewAmhSz9jr/izKLeqyEPUmq56p+9Ls7sf3Du6++hsryRnRse9ZDst\np+Z0OYKla0zzrknROqUrWCks+rmGuAMjHmUqFP14vSYN9F6znsf0I9EnEsLV\ncnflOuspU130zki7foaJmBo/OtyM5Q==\n"
	}

Save that in version control. 

    git add data_bags
	git commit -m "added encrypted data bag for mysql secrets"

Decrypt the data bag if you need to inspect. Just include the --secret-file argument:

	knife data bag show secrets mysql --secret-file ~/.chef/encrypted_data_bag_secret 

Modify the encrypted data bag if you need using the knife data bag edit command:

	knife data bag edit --secret-file ~/.chef/encrypted_data_bag_secret secrets mysql

but make sure to commit any secret changes back into git. Next chef run would apply the changes onto nodes. 

#### Make mysql server recipe use the encrypted data bag

The best practise is to keep customizations to community cookbooks in a separate `site-cookbooks` folder. However, I havn't figured out yet what is the best way to override  mysql community cookbook with this segment of code so resort to a hack and add the following to the top of cookbooks/mysql/recipes/server.rb:

	# Customization: get passwords from encrypted data bag
	secrets = Chef::EncryptedDataBagItem.load("secrets", "mysql")
	if secrets && mysql_passwords = secrets[node.chef_environment] 
	  node['mysql']['server_root_password'] = mysql_passwords['root']
	  node['mysql']['server_debian_password'] = mysql_passwords['debian']
	  node['mysql']['server_repl_password'] = mysql_passwords['repl']
	end

Git will complain if you commit such a hack to version control so its best to remember that this is a hack and needs a cleaner approach to accomplish mysql cookbook to use encrypted data bag item for secrets.

	git add cookbooks/mysql
	git commit -m 'Read MySQL passwords from encrypted data bag.'

upload the updated mysql cookbook to Chef server. 

    knife cookbook upload mysql -o ./cookbooks

#### Spin up a single instance on EC2

This command assumes that you have a key named `awsdefault` and the corresponding `awsdefault-east.pem` pemfile saved in `~/Downloads` folder, that the pemfile is marked read only for you `chmod 400 ~/Downloads/awsdefault-east.pem`, that you have a security group named `webserver` defined on EC2, that you have roles defined and upload onto Chef server, and that have environments also uploaded. The specified AMI ami-9c78c0f5 is the official 64-bit Ubuntu 12.04 EBS image in the us-east-1 region. If you want to use a different EC2 region, select a similar AMI in your desired region from the [ubuntu AMI list](http://cloud-images.ubuntu.com/locator/ec2/). Also, you musts specify the db_master role before the webserver role.

	knife ec2 server create \
	    -S awsdefault -i ~/Downloads/awsdefault-east.pem \
	    -G webserver,default \
	    -x ubuntu \
	    -d ubuntu12.04-gems \
	    -E prod \
	    -I ami-9c78c0f5 \
	    -f m1.small \
	    -r "role[base],role[db_master],role[webserver]" 

After the provisioning is completed, knife will list some details on your new EC2 instalce like this. 

	...
	...
	ec2-50-17-75-229.compute-1.amazonaws.com [2012-12-12T01:19:21+00:00] INFO: Chef Run complete in 259.308362 seconds
	ec2-50-17-75-229.compute-1.amazonaws.com [2012-12-12T01:19:21+00:00] INFO: Running report handlers
	ec2-50-17-75-229.compute-1.amazonaws.com [2012-12-12T01:19:21+00:00] INFO: Report handlers complete

	Instance ID: i-604df61e
	Flavor: m1.small
	Image: ami-9c78c0f5
	Region: us-east-1
	Availability Zone: us-east-1a
	Security Groups: webserver, default
	Security Group Ids: default
	Tags: {"Name"=>"i-604df61e"}
	SSH Key: awsdefault
	Root Device Type: ebs
	Root Volume ID: vol-66fa4619
	Root Device Name: /dev/sda1
	Root Device Delete on Terminate: true
	Public DNS Name: ec2-50-17-75-229.compute-1.amazonaws.com
	Public IP Address: 50.17.75.229
	Private DNS Name: ip-10-101-51-86.ec2.internal
	Private IP Address: 10.101.51.86
	Environment: prod
	Run List: role[base], role[db_master], role[webserver]
	➜  fungibility git:(master) 

At the end of this run, you should see `It works!` page apache generates when you visit the [public url of your amazon ec2 instance](http://ec2-50-17-75-229.compute-1.amazonaws.com) in a web browser. If you run into any errors during provisioning, you can edit the Chef configuration, upload that the Chef server, and then re-run the Chef client directly on the EC2 instance:

	➜  fungibility git:(master) ssh -i ~/Downloads/awsdefault-east.pem ubuntu@ec2-50-17-75-229.compute-1.amazonaws.com

    ec2$ sudo chef-client

Another way without ssh directly is to use knife to do a remote chef run 
	
	knife ssh role:base 'sudo chef-client'

Idempotence would come into play here and make it the fastest way to make config amendments because Chef won’t re-install things that are already installed.

#### Spin up a similar instance on HP Cloud

This command assumes that you have a key named `hpdefault` and the corresponding `hpdefault.pem` pemfile saved in `~/Downloads` folder, that the pemfile is marked read only for you `chmod 400 ~/Downloads/hpdefault.pem`, that you have a security group named `webserver` defined on HP Cloud, that you have roles defined and upload onto Chef server, and that have environments also uploaded. The specified image 120 is the Ubuntu 12.04 EBS image in HP Cloud and 102 is the flavor (standard.medium) of machine used. `knife hp flavor list` will give all flavors of machines available in the HP cloud. Also, you musts specify the db_master role before the webserver role.

	knife hp server create \
	    -S hpdefault -i ~/Downloads/hpdefault.pem \
	    -G webserver,default \
	    -x ubuntu \
	    -d ubuntu12.04-gems \
	    -E prod \
	    -I 120 \
	    -f 102 \
	    -r "role[base],role[db_master],role[webserver]" 

After provisioning, knife will print out some details on your HP instance.

	...
	15.185.226.228 [2012-12-12T01:39:55+00:00] INFO: Chef Run complete in 132.742629 seconds
	15.185.226.228 [2012-12-12T01:39:55+00:00] INFO: Running report handlers
	15.185.226.228 [2012-12-12T01:39:55+00:00] INFO: Report handlers complete

	Instance ID: 403017
	Instance Name: hp15-185-227-146
	Flavor: 102
	Image: 120
	SSH Key Pair: hpdefault
	Public IP Address: 15.185.226.228
	Private IP Address: 10.2.2.51
	Environment: prod
	Run List: role[base], role[db_master], role[webserver]

You should be able to `It works!` page when you visit the [public url of your hp instance](http://15.185.227.146) in a web browser. You just witnessed what I would refer to as the rudimentary beginnings of fungibility of cloud machines. Now that you have two instances running identical configuration but on machines from two different providers. 

Let's query the cloud instances using knife. 

	➜  fungibility git:(master) knife hp server list 
	Instance ID  Name              Public IP       Private IP  Flavor  Image  Key Pair   State 
	403017       hp15-185-227-146  15.185.226.228  10.2.2.51   102     120    hpdefault  active
	
	➜  fungibility git:(master) knife ec2 server list
	Instance ID  Name        Public IP     Private IP    Flavor    Image         SSH Key     Security Groups     State  
	i-604df61e   i-604df61e  50.17.75.229  10.101.51.86  m1.small  ami-9c78c0f5  awsdefault  default, webserver  running
	
and globally check `uptime`, `restart apache` and also run a `sudo chef-client` on all machines with `base` role.

    knife ssh role:base 'uptime'
	knife ssh role:base 'sudo service apache restart'
	knife ssh role:base 'sudo chef-client'
	
	# Restart Apache on all webservers
	knife ssh role:webserver 'service apache restart'

	# Check the free disk space on all nodes
	knife ssh name:* 'df -h'
	
#### Delete the machines you just created

List them out using knife

	➜  fungibility git:(master) knife hp server list 
	Instance ID  Name              Public IP       Private IP  Flavor  Image  Key Pair   State 
	403017       hp15-185-227-146  15.185.226.228  10.2.2.51   102     120    hpdefault  active
	
	➜  fungibility git:(master) knife ec2 server list
	Instance ID  Name        Public IP     Private IP    Flavor    Image         SSH Key     Security Groups     State  
	i-604df61e   i-604df61e  50.17.75.229  10.101.51.86  m1.small  ami-9c78c0f5  awsdefault  default, webserver  running

Delete the server instances, node, and client using knife:

	#cleaning up HP
	knife hp server delete 403017
	INSTANCE=hp15-185-227-146 
	knife node delete $INSTANCE
	knife client delete $INSTANCE	

	# cleaning up AWS EC2
	INSTANCE=i-604df61e
	knife ec2 server delete $INSTANCE
	knife node delete $INSTANCE
	knife client delete $INSTANCE

While deleting, you will notice that there are some minor differences between HP and AWS EC2 in the way knife deletion works.

####Provision the vagrant box

Now that you have the configuration working on two different cloud providers, lets configure vagrant in a similar fashion so we can use that as a development environment. Create a directory on your workstation for your vagrant VM that would be shared with the vagrantbox. This is where your dev work will reside in subdirectories within this folder.

	VMDIR=~/dev/vagrant-vm
	mkdir -p $VMDIR
	cd $VMDIR

Next, download and save this as `$VMDIR/Vagrantfile` to help create and provision the vagrantbox. 

{% include_code Vagrantfile lang:ruby %}

In this Vagrantfile, make sure to set orgname to the orgname you use in Hosted Chef. The node must be unique among all nodes that use your Chef server. You can override it by exporting a `$NODE` environment variable, or you can accept the default `vagrant-$USER`. This Vagrantfile uses NFS for shared folders which is useful on a Mac or Linux host. Omit the `, :nfs => true` argument on a Windows host. Don’t try to mount a shared directory on `/home/vagrant` as it will cause important configuration to be overwritten, such as the .ssh directory (preventing key-based ssh authentication). You can change the amount of memory allocated to the VM with the `config.vm.customize [ "--memory", 2048]` setting (currently configured to allocate 2GB). You must specify the `db_master` role before the `webserver` role.

Next, provision the vagrantbox:

	cd $VMDIR
	vagrant up

Or, to specify a custom NODE name such as `my-cool-vm`:

	NODE=my-cool-vm vagrant up

If you need to tweak the Chef scripts and then re-provision over the top of the existing configuration:

	cd $VMDIR
	vagrant provision # a bug https://github.com/mitchellh/vagrant/issues/1111 ?
	vagrant ssh      # this is a workaround
	sudo chef-client # this is a workaround

To wipe it out and start over:

	NODE=vagrant-$USER
	cd $VMDIR
	vagrant destroy
	knife node delete $NODE
	knife client delete $NODE

Check if vagrantvm set up correctly by opening http://localhost:8080 in your browser to see the `It works!` page.
