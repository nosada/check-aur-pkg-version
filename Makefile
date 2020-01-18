SHELL := /bin/bash

HOME_DIRECTORY=$(shell echo ${HOME})
REPOSITORY_LOCATION=$(shell pwd)
VENV_LOCATION=${HOME_DIRECTORY}/Venvs
USER_SYSTEMD_LOCATION=${HOME_DIRECTORY}/.config/systemd/user

FILES=check-aur-pkg-version \
      check-aur-pkg-version.service \
      check-aur-pkg-version.timer \
      requirements.txt \
      config.yaml
TEMPLATE=check-aur-pkg-version.service.tmpl
NAME=check-aur-pkg-version

FILES_FOR_DOCKER=check-aur-pkg-version \
		 requirements.txt \
		 Dockerfile \
		 .dockerignore \
		 config.yaml
TEMPLATE_DOCKER=check-aur-pkg-version.service.docker.tmpl
DOCKER_IMAGE_NAME=local/${NAME}:latest

all: generate-systemd-service install-using-docker set-up-python activate-systemd-services

install: ${FILES}
	install -Dm 644 ${NAME}.service ${USER_SYSTEMD_LOCATION}
	install -Dm 644 ${NAME}.timer ${USER_SYSTEMD_LOCATION}

install-using-docker: build-docker-image generate-docker-systemd-service
	install -Dm 644 ${NAME}.service ${USER_SYSTEMD_LOCATION}
	install -Dm 644 ${NAME}.timer ${USER_SYSTEMD_LOCATION}

set-up-python:
	python -m venv ${VENV_LOCATION}/${NAME}
	source ${VENV_LOCATION}/${NAME}/bin/activate
	${VENV_LOCATION}/${NAME}/bin/pip install --upgrade pip
	${VENV_LOCATION}/${NAME}/bin/pip install -r requirements.txt

generate-systemd-service: ${TEMPLATE}
	sed -e 's;VENV_LOCATION;'${VENV_LOCATION}';g' -e 's;REPOSITORY_LOCATION;'${REPOSITORY_LOCATION}';g' ${TEMPLATE} > ${NAME}.service

generate-docker-systemd-service: ${TEMPLATE_DOCKER}
	sed -e 's;IMAGE_NAME;'${DOCKER_IMAGE_NAME}';g' -e 's;REPOSITORY_LOCATION;'${REPOSITORY_LOCATION}';g' ${TEMPLATE_DOCKER} > ${NAME}.service

build-docker-image: ${FILES_FOR_DOCKER}
	docker-compose build

activate-systemd-services:
	systemctl --user enable ${NAME}.service
	systemctl --user enable ${NAME}.timer
	systemctl --user start ${NAME}.timer
	systemctl --user daemon-reload

deactivate-systemd-services:
	systemctl --user disable ${NAME}.service
	systemctl --user disable ${NAME}.timer
	systemctl --user stop ${NAME}.timer
	systemctl --user daemon-reload

clean: ${NAME}.service
	rm -f ${NAME}.service

uninstall: deactivate-systemd-services
	rm -f ${USER_SYSTEMD_LOCATION}/${NAME}.service
	rm -f ${USER_SYSTEMD_LOCATION}/${NAME}.timer
	rm -rf ${VENV_LOCATION}/${NAME}
	docker rmi -f ${DOCKER_IMAGE_NAME}
