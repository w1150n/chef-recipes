# Since we have our workaround to /etc/apt/preferences.d bug
# we just need to delete the pinning attribute and the template will be
# regenerated without the pinning

define :remove_apt_preferences do
  node.normal_attrs[:apt][:pins].delete(params[:name]) rescue nil
end
