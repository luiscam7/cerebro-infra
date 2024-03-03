format:
	terraform fmt

test:
	terraform test

validate:
	terraform validate

deploy:
	terraform apply --auto-approve