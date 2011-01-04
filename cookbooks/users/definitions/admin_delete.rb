define :admin_delete do

  u=params[:name]
  u="rgo"
  execute "find / -path /proc -prune -o -user #{u} -delete" do
    creates "/var/tmp/.deleted-files-#{u}"
    returns 1
  end

  user u do
    action :remove
  end

  file "/var/tmp/.deleted-files-#{u}"

#  This is for chef 0.9
#   node.automatic_attrs[:users].delete(u.to_sym) rescue nil
#   node.override_attrs[:users].delete(u.to_sym) rescue nil
#   node.normal_attrs[:users].delete(u.to_sym) rescue nil
#   node.default_attrs[:users].delete(u.to_sym) rescue nil

  node.attribute[:users].delete(u.to_sym)
end
