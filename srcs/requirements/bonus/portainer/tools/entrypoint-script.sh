#!/bin/bash
set -eo pipefail

# extract .tar file
if [ ! -x "/portainer/portainer" ]; then
  test -f /portainer.tar.gz
  tar -xzf /portainer.tar.gz -C /
fi

if [ ! -f "/data/portainer.db" ]; then

    #run portainer as temporary background process to set the admin password
    /portainer/portainer --admin-password-file /run/secrets/portainer_admin_password &
    PID=$!
    
    #check if initialization is complete
    while [ ! -f "/data/portainer.db" ]; do
        sleep 1
    done

    kill $PID || true
    wait $PID || true
fi

exec /portainer/portainer