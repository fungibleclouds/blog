current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                'nilesh'
client_key               '/Users/nilesh/.chef/nilesh.pem'
validation_client_name   'chef-validator'
validation_key           '/Users/nilesh/.chef/validation.pem'
chef_server_url          'http://chefserver.somewhereinthecloud.net:4000'
cache_type               'BasicFile'
cache_options( :path => '/Users/nilesh/.chef/checksums' )
cookbook_path            ["#{current_dir}/../cookbooks"]

cookbook_copyright       "Your Name"
cookbook_email           "your@email.addr"
cookbook_license         "apachev2"

encrypted_data_bag_secret "#{current_dir}/encrypted_data_bag_secret"

knife[:aws_ssh_key_id]        = "awsdefault"
knife[:aws_access_key_id]     = "asdasdasdasdasdasd"
knife[:aws_secret_access_key] = "asdasdasdasdasdasdasdasdasdasdasdasd"

knife[:hp_account_id] = "asdasdasdasdasdasd"
knife[:hp_secret_key] = "asdasdasdasdasdasdasdasdasdasdasdasdasdasd"
knife[:hp_tenant_id]  = "123123123123123"
#knife[:hp_avl_zone]   = "Your HP Cloud Availability Zone" (optional, default is "az1")
#knife[:hp_auth_uri]   = "Your HP Cloud Auth URI" (optional, default is "https://region-a.geo-1.identity.hpcloudsvc.com:35357/v2.0/")
