# Descreption

Using Jenkins pipeline, building VPC with public and private subnets. The public subnet has a bastion host, using to be a proxy server. One of the private subnets has a private instance, configured with Ansible, to be a Jenkins Slave to run on it a Node.js app that connects to an RDS and an ElastiCache Redis instances in another private subnet and exposed to the internet by appliation loadbalancer.

---

# Repo components:
- ansible: this directory has ansible playbook configuration files
- app: this directory has nodejs app files
- aws-infra: this directory has terraform files to build AWS infrastructure
- dockerfile: to build a new image from jenkins with docker client
- jenkinsfile: pipeline file
---

# Tools

<p align="center">
<img src="https://www.vectorlogo.zone/logos/terraformio/terraformio-icon.svg"/>
<img src="https://www.vectorlogo.zone/logos/amazon_aws/amazon_aws-ar21.svg"/>
<img src="https://www.vectorlogo.zone/logos/docker/docker-icon.svg"/>
<img src="https://www.vectorlogo.zone/logos/jenkins/jenkins-icon.svg"/>
<img src="https://www.vectorlogo.zone/logos/ansible/ansible-icon.svg"/>
<img src="https://www.vectorlogo.zone/logos/gnu_bash/gnu_bash-ar21.svg"/>
<img src="https://www.vectorlogo.zone/logos/nodejs/nodejs-ar21.svg"/>
</p>

---

## 1- Build your infrastructure on AWS by Terraform
```bash
$ cd aws-infra
$ terraform init
$ terraform apply --auto-approve
```
---

## 2- Build a new image from jenkins with docker client and run a new container

```bash
# buil new image
$ docker build . -f dockerfile -t jenkins-with-docker-client

# run a new container from this image and link it with docker.sock to use docker inside the jenkins master
$ docker run -d -p 8082:8080 -v /var/run/docker.sock:/var/run/docker.sock jenkins-with-docker-client
```

---

## 3- Make ssh on private instance from jenkins container “jump host”

create ~.ssh/config on Jenkins container

```bash
Host bastion-instance
    User ubuntu
    HostName 18.220.189.242  #bastion ip
    IdentityFile /root/.ssh/terraform_key_pair.pem  #key of the public instance

host app-instance
   HostName  10.0.2.194 #private instance ip
   user ubuntu
   ProxyCommand ssh bastion-instance -W %h:%p
   identityFile /root/.ssh/terraform_key_pair.pem  #key of the private instance
```

<p align="center"> <img src="images/Untitled 3.png"/> </p>

Try to ssh 

```bash
$ ssh app-instance
```

<img src="images/Untitled 4.png"/>

---

## 4- Make a private instance as a jenkins slave and run a pipeline on it

1- Download jar file.<p>
2- Run ansible play book to prepare your instance to be a jenkins slave.

```bash
$ ansible-playbook -i Invetory --private-key terraform_key_pair.pem  ec2_slave_playbook.yml
```

3- Create a new node

<p align="center"> <img src="images/Untitled 6.png"/>
<img src="images/Untitled 5.png"/> </p>
Save, lunch the agent and check your nodes:
<img src="images/Untitled 7.png"/>

Build your pipeline on the new node: 
<img src="images/Untitled 10.png"/>

Get load balancer URL and check your app:
<p align="center"> <img src="images/Untitled 8.png"/>
<img src="images/Untitled 9.png"/> </p>