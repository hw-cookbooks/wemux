node[:wemux][:packages].each do |pkg_name|
  package pkg_name
end

execute 'wemux update' do
  command 'git pull'
  cwd '/opt/wemux'
  only_if{ File.exists?('/opt/wemux/wemux') }
end

execute 'wemux clone' do
  command 'git clone https://github.com/zolrath/wemux'
  cwd '/opt'
  creates '/opt/wemux/wemux'
end

link '/usr/local/bin/wemux' do
  to '/opt/wemux/wemux'
end

link '/usr/bin/wemux' do
  to '/opt/wemux/wemux'
end

directory '/usr/local/etc' do
  recursive true
end

file '/usr/local/etc/wemux.conf' do
  content lazy{
    node[:wemux][:config].map do |k,v|
      if(v.is_a?(Array))
        "#{k}=(#{v.join(' ')})"
      else
        "#{k}=\"#{v}\""
      end
    end.join("\n")
  }
  mode 0644
end

file '/etc/tmux.conf' do
  content lazy{
    [
      "set -g prefix C-#{node[:wemux][:tmux][:control_key]}",
      "unbind C-b",
      "bind C-#{node[:wemux][:tmux][:control_key]} send-prefix",
      "set-window-option -g allow-rename off",
      "set-window-option -g automatic-rename off",
      *node[:wemux][:tmux].fetch(:config, [])
    ].join("\n") << "\n"
  }
  mode 0644
  only_if{ node[:wemux][:tmux][:write] }
end
