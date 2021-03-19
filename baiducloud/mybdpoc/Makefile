all:
	terraform init
	terraform apply -auto-approve
	cd ../enum_instances; make $@

clean:
	terraform destroy -auto-approve
	cd ../enum_instances; make $@

.PHONY: all clean
