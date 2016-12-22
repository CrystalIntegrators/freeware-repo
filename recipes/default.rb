#
# Cookbook Name:: ricApache
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

group 'web' do
  action :create
end

user 'apache' do
  comment 'Apache system user'
  system true
  group 'web'
  home '/webapp/apache'
  shell '/bin/bash'
end

