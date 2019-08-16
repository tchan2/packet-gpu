# packet-gpu
A first step example of creating an environment that allows for the implementation of deep learning in a GPU supported Ubuntu Packet server using Terraform.

## Table of Contents
1. [Before You Begin](#before-you-begin) 
2. [Getting Started](#getting-started) 
3. [Clone The Repository](#clone-the-respository) 
4. [Initialize Terraform](#initialize-terraform) 
5. [Set Necessary Variables](#set-necessary-variables) 
    - [`auth_token`](#auth_token)
    - [`project_id`](#project_id)
        - [If you do not have a project](#if-you-do-not-have-a-project)
        - [If you already have a project](#if-you-already-have-a-project) 
6. [Initialize Terraform](##initialize-terraform) 
7. [Deploying the Packet Server](#deploying-the-packet-server)
8. [Entering Your Server](#entering-your-server)
9. [Check The Script](#check-the-script)
10. [Create Jupyter Notebook](#create-a-jupyter-notebook)
11. [<i>Optional</i>: Secure Your Jupyter Notebook](#optional-secure-your-jupyter-notebook)
    - [Sign Up](#sign-up)
    - [Create a Hostname](#create-a-hostname)
    - [Set Your IP Address](#set-your-ip-address)
    - [Add Your Hostname](#add-your-hostname)
    - [Run Script](#run-script)


## Before You Begin
This guide was created for users who may not have Linux machines with GPU supported drivers, or want to engage in machine learning research with the use of bare metal servers. We will be using a [GPU accelerated Packet server](https://www.packet.com/cloud/) to implement a machine learning environment, which will require a [Packet account](https://app.packet.net/login) to be created, and the use of this server will have an hourly billing fee. 

Please keep in mind that the device created will have <b> Ubuntu 16.04</b> as the operating system and several packages and installations will be installed automatically. It will be helpful to have prior knowledge in Linux commands and the following installations, but you may install other applications to aid you in your machine learning research as desired:

- Anaconda
- Docker CE
- Nvidia Docker
- Cuda 10.1
- Tensorflow-GPU
- Jupyter


## Getting Started
Begin by [installing Terraform](https://www.terraform.io/downloads.html) on your machine. (A Mac was used in the making of this guide, but you may use any machine as long as Terraform supports installation for your operating system). 

Please ensure that you download the file with the correct operating system and architecture of the machine you will be using Terraform on.

Verify that your Terraform installation has been performed successfully and that your `PATH` has been set correctly by running the `terraform` command.

You should get the following output:
```
Usage: terraform [-version] [-help] <command> [args] 
(...)
```

><i> For further help on installing Terraform on your operating system, please visit Terraform's [Getting Started](https://learn.hashicorp.com/terraform/getting-started/install.html) guide. </i>


## Clone the Repository
Clone this repository to have all the necessary files needed to easily deploy a server with GPU support.

This can be done by entering the following: 
```
$ git clone https://github.com/tchan2/packet-gpu
```

Now you should have all the necessary files for deploying a Packet server with GPU acceleration.


## Set Necessary Variables
After cloning the repository, enter the `packet-gpu` directory and go into the `variables.tf` file.

You will see that variables `auth_token` and `project_id` have been left blank.

### `auth_token`
Please enter your API key in the quotes indicated in the `default` field. If you do not, Terraform will give an error stating that you do not have the correct authentication token needed to create this server.
```
variable "auth_token" {
    (...)
    default = "<YOUR_API_TOKEN_HERE>"
}
```
### `project_id`
### If you do not have a project...
As a default, it has been assumed that a project has not been created, so the following block of code in `packet-gpu.tf` creates the packet_project resource:

```
resource "packet_project" "your_project_name" {
    name = "Your Project Name"
}
```
Your project name has been defaulted to `tf_project` and the name has been defaulted to `Project 1`, but you may customize it accordingly.

If you have changed the project name, please also adjust the following code to fit your project name. Otherwise, leave it alone: 
```
resource "packet_device" "tf-gpu" {
    (...)
    project_id = "${packet_project.your_project_name.id}"
}
```
>Please visit the section on [packet_project](https://www.terraform.io/docs/providers/packet/r/project.html) on the Terraform Packet Provider page for more information of other fields you can add to customize your Packet project even further!

<i> You may now skip to the [Initialize Terraform](#initialize-terraform) section of this page. </i>

#### If you already have a project...
If you have already created a project in your Packet account and would like to use it, first change the value of `have_proj_id` to `true`. It has been defaulted to `false`.

```
variable "have_proj_id" {
    default = true
    # originally
    # default = false
}
```
> Make sure you set the value of `have_proj_id` to true, or else another project will be created, and you will be billed for it!

Now, enter your project ID in the `default` field and uncomment it. Your project ID can be found by going into your preferred project, and taking the portion of text after `https://app.packet.net/projects/<YOUR_PROJECT_ID>`.

```
variable "project_id" {
    (...)
    default = "<YOUR_PROJECT_ID_HERE>"
}
```

Then, head into the `packet-gpu.tf` file. Change the `project_id` field of the packet_device resource from `"${packet_project.tf_project.id}"` to `"${var.project_id}"`:
```
resource "packet_device" "tf-gpu" {
    project_id            = "${var.project_id}"
    # originally... 
    # project_id          = "${packet_project.tf_project.id}"
(...)
```

<i> After you are done, please continue to the [Initialize Terraform](#initialize-terraform) section below. </i>

## Initialize Terraform
In order to deploy the Packet server, we must initialize Terraform for deployment. We do this by entering the following:
```
$ terraform init
```

Now, we can view the plan for deployment by running:
```
$ terraform plan
```

This will show what resources will be added, changed, or destroyed. Please look this plan over to ensure that it is to your preferences.


## Deploying the Packet Server
If everything looks good, we can start deploying our Packet server. Run the following:
```
$ terraform apply
```
Check the plan again, and answer `yes` if everything is to your liking.

If all the steps have been completed successfully, a Packet server will have been deployed!


## Enter Your Server
Open up a terminal, and SSH into your device. You may do this by entering:
```
ssh -L 8888:localhost:8888 root@PUBLIC_IPv4_ADDRESS
```

The IP address of your server can be found by logging into your Packet account and checking there, or by searching the `terraform.tfstate` file that has just been created after running `terraform apply`. 

Once there, please create a passphrase to secure your server.

Now, enter into your user account!
```
$ su - user
```

## Check the Script
In order to use the packages and installations in this server, it will be required that the script running in the server's user data has been completed.

To check the progress of this script, please run:
```
$ cat /var/log/cloud-init-output.log
```
You may run this commmand as many times as you would like as the log will update as the script runs in the background.

Once you see
```
(...)
echo "Completed. Script finished."
Completed. Script finished.
```
at the bottom of the `cloud-init-output` log, the script has been completed.


## Create a Jupyter Notebook
To create a Jupyter notebook and run it in a Conda environment all in one, run these commands: 

```
$ wget -O postinstall.sh https://raw.githubusercontent.com/tchan2/packet-gpu/master/scripts/postinstall.sh

$ chmod +x postinstall.sh

$ ./postinstall.sh
```

This will test your installations and make sure that they have installed correctly, create and activate an GPU-supported Anaconda environment, and create a Jupyter notebook!

Once this runs, you will see a link like the following that you can use to access your Jupyter notebook:

```
[C 16:21:28.754 NotebookApp] 
(...)
    Or copy and paste one of these URLs:
        http://localhost:8888/?token=<YOUR-PERSONALIZED-TOKEN>

```
Just copy and paste this link into your preferred browser, and begin coding! 

## <i>Optional: Secure Your Jupyter Notebook</i>
If you would like to secure your Jupyter notebook with HTTPS using a SSL certificate, and also be able to access it by entering your custom domain name, please follow these steps!

### Sign Up
Please go on [no-ip.com](https://no-ip.com) to create a free domain name! Sign up using your preferred email, and fill out any necessary fields.

### Create a Hostname
In order to create a hostname, please refer to the sidebar to the left.

Click on <b>My Services</b>, and then click on <b>DNS Records</b>. You will see a button that says <i>Add a Hostname</i>.

> If you would like to pay for a domain with no-ip.com, you may click on <b>Domain Registration</b>! 

Please set your hostname, and your preferred domain. For this guide, we will be using `example.ddns.net`.

For the <b>Hostname Type</b>, please set it to <b> DNS Hostname (A)</b>. 

### Set your IP Address
After you have created your domain name, please insert your public IPv4 address into the IP Address field.

### Add your Hostname
Click on <b> Add Hostname </b> and you have successfully created your domain name!

Please allow at least 5-10 minutes for this change to take place.

### Run Script
If you try to enter in your domain name, you will see that your page does not work!

This is due to your Jupyter notebook being on port 8888 (or whatever port you have set it on), and as you can see, your domain name does not have SSL enabled!

Thankfully, I have created a script to make it easy for you to enable SSL, and for you to access your Jupyter notebook with just your domain name!

### Set Domain Name
First, run the following to get my script onto your Packet server.
```
$ wget -O sslwrap.sh https://raw.githubusercontent.com/tchan2/packet-gpu/master/scripts/sslwrap.sh
```
Now, you should be able to enter and edit the script. Run the following:
```
$ sudo nano sslwrap.sh
```

You will see that on the top of the script, you can set your domain name! Please edit it as necessary.
```
# Set your domain name here
domain=example.ddns.net
```

Please exit and save the file, and run the script:
```
$ chmod +x sslwrap.sh

$ ./sslwrap.sh
```
> If you would add extra security, please run `jupyter notebook password` to set a password for your notebook after the script has ran!

Now you're done! Please allow a bit of time for the changes to occur, and now you can easily go on your domain name to access your Jupyter notebook.