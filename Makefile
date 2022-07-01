.PHONY: setup generate

setup:
	pip3 install virtualenv
	virtualenv ${PWD}/venv -p python3
	${PWD}/venv/bin/pip install cookiecutter

generate:
	${PWD}/venv/bin/cookiecutter -o ${PWD}/output --overwrite-if-exists ${PWD}