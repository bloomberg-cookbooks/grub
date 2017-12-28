name 'default'
default_source :community
cookbook 'blp-grub', path: '.'
run_list 'blp-grub::default'
named_run_list :centos, 'sudo::default', 'yum::default', 'yum-epel::default', run_list
named_run_list :debian, 'sudo::default', 'apt::default', run_list
named_run_list :freebsd, 'freebsd::default', run_list
named_run_list :windows, 'windows::default', run_list

override['grub']['config']['settings']['timeout'] = 30
override['grub']['config']['settings']['distributor'] = "$(sed 's, release .*$,,g' /etc/system-release)"
override['grub']['config']['settings']['terminal_output'] = "console"
