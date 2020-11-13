all:
	terraform apply -auto-approve && sleep 10
	bash -c 'source ${HOME}/workspace/ansible_venv/bin/activate && cd ./ansible_ubuntu18.04_k8s1.17.3 && ansible-playbook -i hosts.ini site.yaml'
	terraform output

clean:
	terraform destroy -auto-approve

.PHONY: all clean
