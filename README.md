# blp-grub cookbook

[![Build Status](https://img.shields.io/travis/bloomberg-cookbooks/grub.svg)](https://travis-ci.org/bloomberg-cookbooks/grub)
[![Cookbook Version](https://img.shields.io/cookbook/v/blp-grub.svg)](https://supermarket.chef.io/cookbooks/blp-grub)
[![License](https://img.shields.io/github/license/bloomberg-cookbooks/grub.svg?maxAge=2592000)](http://www.apache.org/licenses/LICENSE-2.0)

Cookbook which configures the Grub Bootloader.

## Platforms

The following platforms are tested automatically
using [Test Kitchen][0], in Docker, with
the [default suite of integration tests][2]:

- Ubuntu 12.04/14.04/16.04
- CentOS (RHEL) 6/7

## Basic Usage
The [default recipe](recipes/default.rb) gives you the ability to pass
attributes to tune your grub settings.  There are currently no
defaults in this cookbook so your regular distrobution provided grub
file will remain intact.  You can tweak the settings in the
Policefile.rb or directly using attributes. All GRUB specific settings
should use underscores like the examples below.

### Hash merging
Values provided as hashes (under `['grub']['config']['settings'][key]`)
will be merged/flattened to form strings.
This is intended to allow overrides to, for example, kernel boot options without ugly string manipulation.

This approach is probably best demonstrated using an example:

```ruby
default['grub']['config']['settings']['cmdline_linux']['biosdevname'] = '0'
default['grub']['config']['settings']['cmdline_linux']['nomodeset'] = nil
default['grub']['config']['settings']['cmdline_linux']['console'] = [ 'tty0', 'ttyS1,115200n8']
```

is the precise equivalent of
```ruby
default['grub']['config']['settings']['cmdline_linux'] = 'biosdevname=0 nomodeset console=tty0 console=ttyS1,115200n8'
```

Using hashes permits simple overrides like the following
```ruby
node.override[grub']['config']['settings']['cmdline_linux']['biosdevname'] = '1'
```

### How hash values are merged
for each key = value pair in the hash:

  * if value is `nil`, it is omitted and the key is inserted without a value
    `...[cmdline_linux']['nomodeset'] = nil` results in `nomodeset`

  * if value is an array, the result is key=v1 key=v2... for each value in the array
    `...['cmdline_linux']['console'] = [ 'x', 'y'']` results in `console=x console=y`

  * otherwise we simply insert key=value
    `...['cmdline_linux']['biosdevname'] = '0'` results in `biosdevname=0`


To permit overrides to (for example) commandline options it is possible to specify

### Recipe
```ruby
node.default['grub']['config']['settings']['timeout'] = 30
node.default['grub']['config']['settings']['distributor'] = "$(sed 's, release .*$,,g' /etc/system-release)"
node.default['grub']['config']['settings']['terminal_output'] = "console"
```

### Policyfile
``` ruby
name 'grub'
default_source :community
run_list 'blp-grub::default'

override['grub']['config']['settings']['timeout'] = 30
override['grub']['config']['settings']['distributor'] = "$(sed 's, release .*$,,g' /etc/system-release)"
override['grub']['config']['settings']['terminal_output'] = "console"
```

[0]: https://docs.ruby-lang.org/en/2.1.0/Gem/ConfigFile.html
[1]: https://rubygems.org/
[2]: https://github.com/bloomberg-cookbooks/grub/blob/master/test/integration/default/default_spec.rb
[3]: https://github.com/chef/omnibus
[4]: https://github.com/bloomberg-cookbooks/grub/blob/master/recipes/default.rb
