describe file('/etc/default/grub') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should contain 'GRUB_TIMEOUT' }
  its(:content) { should contain 'GRUB_DISTRIBUTOR' }
  its(:content) { should contain 'GRUB_TERMINAL_OUTPUT' }
end

