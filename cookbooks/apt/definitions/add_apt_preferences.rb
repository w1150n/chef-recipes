# There is a bug in apt that prevents files placed in /etc/apt/preferences.d/ to have effect
# when pinning. We are using this template based workaroud so we can provide pinning from
# various packages in one file (/etc/apt/preferences)

define :add_apt_preferences do
  node.set[:apt][:pins][params[:name]] = [params[:packages], params[:pin], params[:pin_priority]]
end
