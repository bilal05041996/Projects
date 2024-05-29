#!/bin/bash
<< task
Deploy a Django app
and handle the code for errors
task

code_clone()
{
	echo "Cloning the Djaongo app"
	#Clone the repository
	git clone https://github.com/LondheShubham153/django-notes-app.git
	#first time it will work. If your run again, it gives an error. You need to handle the error
}

#Install the libraries for docker, nginix
install_requirements()
{
	echo "Installing dependencies"
	#sudo apt-get install docker.io nginx -y docker-compose
	sudo apt-get install docker.io nginx -y
}

required_restart()
{
	#Give permission to current user for given file
	sudo chown $USER /var/run/docker.sock
	#When system boots, these services will automaticlly restart
	sudo systemctl enable docker
	sudo systemctl enable nginx
	#Restarting docker because there was an issue with docker file
	sudo systemctl restart docker 
}

deploy()
{
	#Build the app
	docker build -t notes-app .
	#Run the app
	docker run -d -p 8000:8000 notes-app:latest
        #Run using docker-compose
	#using up, it will start
	#docker-compose up -d
}

echo "Deployment Started"
#If there is an issue with code clone, plaes go to given folder
if ! code_clone;
then
	echo "The code directory already exist"
	cd django-notes-app
fi
if ! install_requirements;
then
	echo "Installation failed"
	exit 1
fi
if ! required_restart;
then
	echo "SYSTEM ISSUE"
	exit 1
fi
if ! deploy;
then
	echo "Deployment failed, mail to admin"
	# sendmail
	exit 1
fi
echo "Deployment get finished"
