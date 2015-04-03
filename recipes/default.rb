#
# Cookbook Name:: php-env
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# we need to save the resource variable to get the key and certificate file paths
cert = ssl_certificate 'my-webapp' do
  # we want to be able to use node['my-webapp'] to configure the certificate
  namespace node['my-webapp']
  notifies :restart, 'service[apache2]'
end

include_recipe 'apache2'
include_recipe 'apache2::mod_php5'

case node[:platform]
  when "ubuntu","debian"
    package "php5-curl" do
      action :install
    end
  when "centos"
end

include_recipe 'apache2::mod_ssl'
web_app 'my-webapp' do
  # this cookbook includes a virtualhost template for apache2
  cookbook 'ssl_certificate'
  #server_name cert.common_name
  docroot node['my-webapp']['docroot']
  ssl_key cert.key_path
  ssl_cert cert.cert_path
  ssl_chain cert.chain_path
end

include_recipe 'apache2::mod_php5'
template 'phpinfo.php' do
  path "#{node['my-webapp']['docroot']}/phpinfo.php"
  source "phpinfo.php.erb"
  owner 'root'
  group 'root'
  notifies :restart, 'service[apache2]'
end

directory "#{node['my-webapp']['docroot']}/ne_api_sdk_php/" do
  owner 'root'
  group 'root'
  mode  '0755'
  action :create
end

%w{api_find.php api_upload.php login_only.php}.each do |app|
  template app do
    path "#{node['my-webapp']['docroot']}/ne_api_sdk_php/#{app}"
    source "ne_api_sdk_php/#{app}.erb"
    owner 'root'
    group 'root'
    mode  '0755'
    variables(
        CLIENT_ID: node['ne-Api']['client_id'],
        CLIENT_SECRET: node['ne-Api']['client_secret']
    )
  end
end

template 'neApiClient.php' do
  path "#{node['my-webapp']['docroot']}/ne_api_sdk_php/neApiClient.php"
  source "ne_api_sdk_php/neApiClient.php.erb"
  owner 'root'
  group 'root'
  mode  '0755'
  variables(
      CLIENT_ID: node['ne-Api']['client_id'],
      CLIENT_SECRET: node['ne-Api']['client_secret']
  )
  notifies :restart, 'service[apache2]'
end