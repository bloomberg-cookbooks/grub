#
# Cookbook: blp-grub
# License: Apache 2.0
#
# Copyright 2015-2017, Bloomberg Finance L.P.
#

provides :grub
provides :grub_config

property :path, String, name_property: true
property :settings, Hash, default: {}

def content
  settings.merge({}) do |_k, _o, n|
    next n.flatten.map(&:to_s).join(',') if n.is_a?(Array)
    n
  end.map do |k, v|
    'GRUB_' << k.upcase << (v.is_a?(String) ? "=\"#{v}\"" : "=#{v}")
  end.join("\n")
end

action :create do
  file new_resource.path do
    content new_resource.content
  end
end
