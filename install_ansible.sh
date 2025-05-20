#!/usr/bin/env bash
set -euo pipefail
PUBKEY=$(<~/.ssh/id_ansible.pub)          # public part of the key you’ll use from Ansible
PASSWORD='StrongP@ss1!'                  # vault this in real life

az cloud set --name AzureUSGovernment

for sub in $(az account list --query "[].id" -o tsv); do
  az account set --subscription "$sub"

  # ---- Linux VMs ----
  az vm list -d --query "[?storageProfile.osDisk.osType=='Linux' && powerState=='VM running'].[id,resourceGroup,name]" -o tsv |
  while read -r ID RG NAME; do
    az vm run-command invoke \
       --ids "$ID" \
       --command-id RunShellScript \
       --scripts @"scripts/linux_create_ansible_user.sh" \
       --parameters "ansible" "$PUBKEY"
  done

  # ---- Windows VMs ----
  az vm list -d --query "[?storageProfile.osDisk.osType=='Windows' && powerState=='VM running'].[id,resourceGroup,name]" -o tsv |
  while read -r ID RG NAME; do
    az vm run-command invoke \
       --ids "$ID" \
       --command-id RunPowerShellScript \
       --scripts @"scripts/windows_create_ansible_user.ps1" \
       --parameters "password=$PASSWORD"
  done
done
