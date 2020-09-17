
ruby_block 'Default ignored users' do
  block do
    node.default['wemux']['users'][:ignored] = node['wemux']['config']['host_list']
  end
end

wemux_hosts = []

search(node['wemux']['users']['data_bag'], 'id:*').each do |user|
  user['wemux'] ||= {}
  username = user.fetch('username', user['id'])
  wemux_mode = user['wemux'].fetch('mode', 'mirror')
  wemux_admin = user['wemux']['admin']

  if wemux_admin
    wemux_hosts.push(username).uniq!
  end

  file "/home/#{username}/.bashrc" do
    content "wemux #{wemux_mode}; exit"
    not_if { node['wemux']['users']['ignored'].include?(username) }
    mode '644'
  end
end

node.normal['wemux']['config'][:host_list] = wemux_hosts
