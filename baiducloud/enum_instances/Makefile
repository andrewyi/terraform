all:
	terraform init
	terraform apply -auto-approve
	terraform output -json > ./instances.json
	python3 ./inject_ssh_hosts.py

clean:
	terraform destroy -auto-approve
	rm -f ./instances.json
	rm -f ~/.ssh/extra/mybdpoc.conf

.PHONY: all clean
