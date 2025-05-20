pip install 'ansible[azure]==8.*' azure-identity
az login  # or use a Managed Identity
ansible-inventory -i inventory/azure_rm.yaml --graph
ansible linux   -m ping
ansible windows -m win_ping