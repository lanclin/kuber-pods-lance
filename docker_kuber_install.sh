#!/bin/bash
set -x

CURRENTDIR=$(pwd)
HOSTNAME=$(hostname)
MAX_STARTUP_WAIT_CYCLES = 120
CONF_FILE="/etc/apt/sources.list.d/kubernetes.list"

verify_docker_service () {
    WAIT_CYCLES=${MAX_STARTUP_WAIT_CYCLES}
    while [ ${WAIT_CYCLES} -gt 0 ]
    do
        if [ "$(service docker status | grep Active: | awk '{print $3}')" = "(running)" ]; then
            echo " Docker Service UP and Running "
            break
        fi
        echo "Docker not UP - ${WAIT_CYCLES}"
        ${WAIT_CYCLES}=`expr ${WAIT_CYCLES} - 1 `
        sleep 1
    done
}

verify_intetnet_access () {
	
	echo "Pinging the google.com to verify internet connectivity"
	ping -c 2 google.com
	
	if [ "$(ping -c 4 google.com | grep "transmitted" | awk '{print $4}')" = "4"]; then
		echo " Internet connectivity works good "
		break
	fi
	echo " Check the Internet Connectivity - verify the nameserver "
	cat /etc/resolv.conf

}

install_docker () {
	
	echo "Installing the https Certificates and dependency for Docker"
	apt-get install -y apt-transport-https  ca-certificates curl  software-properties-common
	
	echo "Adding the Key for Docker repository "
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	
	echo "Verify the Key fingerprint "
	apt-key fingerprint 0EBFCD88
	
	echo "Adding the Docker Stable Repo on the system " 
	add-apt-repository  "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	
	echo "Update the Ubuntu Packages"
	apt-get update
	
	echo "Installing the Docker Customer Edition"
	apt-get install docker-ce

	echo "Docker Version Check"
	docker --version
		
	if [ "$(docker --version | awk '{print $3}')" ~= [17]]; then 
		echo "Docker version is Latest installed now" 
	else 
		echo "Docker Version is not matched - Please check" 
	fi 
}

install_kubernetes () {
	
	echo "Update the Ubuntu Packages and adding the dependency"
	apt-get update && apt-get install -y apt-transport-https
	
	echo "Adding the Key for Kubernetes"
	curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

	echo "Updating the Kubernetes Repo in Ubuntu Source list"
	echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > $CONF_FILE
	echo "Update the System"
	apt-get update

	echo "Installing the Kubernetes Packages"
	apt-get install -y kubelet kubeadm kubectl
	
	echo " Verify kubernetes"
	kubeadm --help
	kubectl --help
}

################################################
#  Script start
#  Docker Installation on Ubuntu 
#  Kubernetes Installation on Ubuntu
################################################
SERVER_TYPE=$1

case "${SERVER_TYPE}" in

    "Docker" | "docker" | "DOCKER" )
		verify_intetnet_access
        install_docker
        ;;

    "Kubernetes" | "kuber" | "kubernetes" )
		verify_intetnet_access
		install_docker
		install_kubernetes
        ;;
    * )
        echo "Invalid Installation Type Mentioned ${SERVER_TYPE} - Mention docker or kubernetes "
        exit 1
        ;;

esac

#Wait for Docker to come up

verify_docker_service
