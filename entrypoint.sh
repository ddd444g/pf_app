#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /myapp/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"

pf_app-web-1  | /usr/local/bundle/gems/bootsnap-1.16.0/lib/bootsnap/compile_cache/yaml.rb:315:in `realpath': No such file or directory @ rb_check_realpath_internal - /myapp/config/webpacker.yml (Errno::ENOENT)
