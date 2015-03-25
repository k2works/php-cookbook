#
# Cookbook Name:: php-env
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
node.default['my-webapp']['common_name'] = 'localhost'
node.default['my-webapp']['ssl_cert']['source'] = 'self-signed'
node.default['my-webapp']['ssl_key']['source'] = 'self-signed'

# we need to save the resource variable to get the key and certificate file paths
cert = ssl_certificate 'my-webapp' do
  # we want to be able to use node['my-webapp'] to configure the certificate
  namespace node['my-webapp']
  notifies :restart, 'service[apache2]'
end

include_recipe 'apache2'
include_recipe 'apache2::mod_ssl'
web_app 'my-webapp' do
  # this cookbook includes a virtualhost template for apache2
  cookbook 'ssl_certificate'
  #server_name cert.common_name
  docroot "/var/www/html"
  ssl_key cert.key_path
  ssl_cert cert.cert_path
  ssl_chain cert.chain_path
end

include_recipe 'apache2::mod_php5'
template 'phpinfo.php' do
  path '/var/www/html/phpinfo.php'
  source "phpinfo.php.erb"
  owner 'root'
  group 'root'
  notifies :restart, 'service[apache2]'
end