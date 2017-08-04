#disable selinux
selinux_state 'SELinux Disabled' do
  action :disabled
end
