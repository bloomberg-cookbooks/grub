#
# Cookbook: blp-grub
# License: Apache 2.0
#
# Copyright 2015-2017, Bloomberg Finance L.P.
#

grub_config '/etc/default/grub' do
  settings node['grub']['config']['settings']
end
