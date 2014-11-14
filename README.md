# Wemux cookbook

Install and configure wemux

## Usage

Add the default recipe to your run list to
have `wemux` installed and configured on
the system:

```ruby
run_list('recipe[wemux]')
```

Configuration is attribute driven via the
`config` attributes:

```ruby
default_attributes(
  :wemux => {
    :config => {
      :allow_pair_mode => true,
      :allow_rogue_mode => true,
      :allow_server_change => true,
      :host_list => []
    }
  }
)
```

The above is the default configuration applied
by the cookbook. If you want to administer the
wemux session, add your username to the `host_list`
array.

### Tmux configuration

A basic tmux configuration file will be written
to `/etc/tmux.conf`. This configuration will simply
remap the control key from `b` to `q`. This can be
adjusted using the `node[:wemux][:tmux][:control_key]`.

If you do not want this file written, simply disable
it:

```ruby
node.set[:wemux][:tmux][:write] = false
```

### Users

The `wemux::users` recipe is a helper to manage users
via data bag (basically riding on top of the
`users` cookbook. It will look for a `wemux` key
and make changes:

```json
{
  "id": "my_user",
  "wemux": {
    "mode": "mirror", # "pair", "rogue" (defaults "mirror")
    "admin": false
  }
}
```

A `.bashrc` file will be created for users which will
automatically launch wemux in the configured mode and
exit them on detach.

Users with the `admin` flag set to true will automatically
be added to the `host_list` array and will _not_ have their
`.bashrc` file updated.

# Infos

* Repo: https://github.com/chrisroberts/cookbook-wemux