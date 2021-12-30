.ONESHELL:
.SHELL := /bin/bash

init:
	@terraform init

plan:
	@terraform plan

build:
	@terraform apply -auto-approve

clean:
	@terraform destroy -auto-approve

check:
	@sh checkserver.sh

