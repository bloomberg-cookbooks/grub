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

def merge_args(arghash)
    out = []
    arghash.each do |key, val|
      # if a value is an array return key=val for each val in v
      # allows multiple args like console= in kernel boot parameters
      if val.is_a?(Array)
        val.each do |v|
          out << "#{key}=#{v}"
        end
      elsif val.nil?
        # if value is null, just return the key (effectively a boolean flag)
        out << key.to_s
      else
        out << "#{key}=#{val}"
      end
    end
    out.join(' ')
end

def content
  settings.merge({}) do |_k, _o, n|
    next n.flatten.map(&:to_s).join(',') if n.is_a?(Array)
    n
  end.map do |k, v|
    if v.is_a?(Hash)
      v = merge_args(v)
    end
    'GRUB_' << k.upcase << ((v.is_a?(String) && v =~ /[\W\s]+/) ? "=\"#{v}\"" : "=#{v}")
  end.join("\n")
end

action :create do
  file new_resource.path do
    content new_resource.content
  end
end
