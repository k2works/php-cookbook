#
# Cookbook Name:: php-env
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
include_recipe 'php'
include_recipe 'apache2'
include_recipe 'apache2::mod_php5'
