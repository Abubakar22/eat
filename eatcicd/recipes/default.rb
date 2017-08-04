#
# Cookbook:: eatcicd
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'eatcicd::selinux'
include_recipe 'eatcicd::ci'
include_recipe 'eatcicd::cd'
