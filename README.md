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

## 3- Make ssh on private instance from jenkins “jump host”

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

1- Create a jump host first. <p>
2- Download jar file.<p>
3- Run ansible play book to prepare your instance to be a jenkins slave.

```bash
$ ansible-playbook -i Invetory --private-key terraform_key_pair.pem  ec2_slave_playbook.yml
```

4- Create a new node

<img src="images/Untitled 6.png"/>
<img src="images/Untitled 5.png"/>
Save and lunch the agent and check your nodes:
<img src="images/Untitled 7.png"/>

Build your pipeline on the new node: 
<img src="images/Untitled 10.png"/>

Get load balancer URL and check your app:

<img src="images/Untitled 8.png"/>
<img src="images/Untitled 9.png"/>