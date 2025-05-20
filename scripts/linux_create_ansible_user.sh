#!/usr/bin/env bash
# Parameters passed by az run-command invoke
USERNAME=${1:-ansible}
PUBKEY="${2}"
# Idempotent – exits early if user exists
id "$USERNAME"  &>/dev/null && exit 0

useradd -m -s /bin/bash "$USERNAME"
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/99-$USERNAME

install -d -m 700  /home/$USERNAME/.ssh
echo "$PUBKEY" >/home/$USERNAME/.ssh/authorized_keys
chmod 600 /home/$USERNAME/.ssh/authorized_keys
chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
