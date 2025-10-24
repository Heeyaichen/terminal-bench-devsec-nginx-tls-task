#!/usr/bin/env bash
set -euo pipefail


# DOCKER LIMITATION: `iptables-restore` command, which modifies the host's kernel firewall rules,
# cannot be executed in a standard, unprivileged container due to security restrictions.
# While the rest of the solution will fix the Nginx configuration, the iptables
# fix requires the `--privileged` flag to work correctly.
# This is a fundamental Docker security constraint, not a configuration error.
# Fix iptables rules by restoring the correct configuration file.
# This command will fail without the `--privileged` Docker run flag.
iptables-restore < /etc/iptables/rules.v4

# Fix Nginx configuration paths for the TLS certificate and key.
sed -i 's|/etc/ssl/bad_cert.pem|/etc/ssl/cert.pem|g' /etc/nginx/sites-available/default
sed -i 's|/etc/ssl/bad_key.pem|/etc/ssl/key.pem|g' /etc/nginx/sites-available/default

# Restart Nginx to apply the configuration changes and bring the service online.
service nginx restart

echo "Solution applied. Now run ./run-tests.sh to verify."