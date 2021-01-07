#!/bin/sh
set -e
/opt/duoauthproxy/bin/authproxyctl start
exec "$@"
