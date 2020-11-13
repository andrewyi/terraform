all:
	terraform init && terraform apply -auto-approve && sleep 10
	bash -c 'source ~/workspace/ansible_venv/bin/activate && ansible-playbook -i hosts.ini site.yaml'
	terraform output

clean:
	terraform destroy -auto-approve
	# rm -f terraform.tfstate*

.PHONY: all clean
