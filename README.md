# general steps
pip install 'ansible[azure]==8.*' azure-identity
az login  # or use a Managed Identity
ansible-inventory -i inventory/azure_rm.yaml --graph
ansible linux   -m ping
ansible windows -m win_ping

# node steps
sudo dnf install -y python3-pip gcc python3-devel
python3 -m venv ~/.venvs/ansible
source ~/.venvs/ansible/bin/activate
pip install --upgrade pip
pip install "ansible[azure]==8.*" azure-identity

# ssh generatation
bash scripts/run_bootstrap_all_subs.sh
