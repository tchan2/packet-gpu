# packet-gpu
A first step example of creating an environment that allows for the implementation of deep learning in a GPU supported Ubuntu Packet server using Terraform.

# Before You Begin
This guide was created for users who may not have Linux machines with GPU supported drivers, or want to engage in machine learning research with the use of bare metal servers. We will be using a [GPU accelerated Packet server](https://www.packet.com/cloud/) to implement a machine learning environment, which will require a [Packet account](https://app.packet.net/login) to be created, and the use of this server will have an hourly billing fee. 

Please keep in mind that the device created will have <b> Ubuntu 16.04</b> as the operating system and several packages and installations will be installed automatically. It will be helpful to have prior knowledge in Linux commands and the following installations, but you may install other applications to aid you in your machine learning research as desired:

- Anaconda
- Docker CE
- Nvidia Docker
- Cuda 10.1
- Tensorflow-GPU
- Jupyter

# Table of Contents
1. [Getting Started](#getting-started) 
2. [Clone The Repository](#clone-the-respository) 
3. [Initialize Terraform](#initialize-terraform) 
4. [Set Necessary Variables](#set-necessary-variables) 
    - [`auth_token`](#auth_token)
    - [`project_id`](#project_id)
        - [If you do not have a project](#if-you-do-not-have-a-project)
        - [If you already have a project](#if-you-already-have-a-project) 
5. [Initialize Terraform](##initialize-terraform) 
6. [Deploying the Packet Server](#deploying-the-packet-server)
7. [Entering Your Server](#entering-your-server)
8. [Check The Script](#check-the-script)
9. [Create a Jupyter Notebook Without a Domain Name](#create-a-jupyter-notebook-without-a-domain-name)
10. [Create a Jupyter Notebook With a Domain Name](#create-a-jupyter-notebook-with-a-domain-name)
    - [Sign Up](#sign-up)
    - [Create a Hostname](#create-a-hostname)
    - [Set Your IP Address](#set-your-ip-address)
    - [Add Your Hostname](#add-your-hostname)
    - [Run Script](#run-script)
    
    
11. [Acknowledgments](#acknowledgments)

<br />

## Getting Started
Begin by [installing Terraform](https://www.terraform.io/downloads.html) on your machine. (A Mac was used in the making of this guide, but you may use any machine as long as Terraform supports installation for your operating system).

Please ensure that you download the file with the correct operating system and architecture of the machine you will be using Terraform on, or use a package manager (like [Homebrew](https://brew.sh) if you have a Mac or Linux machine, or [Chocolatey](https://chocolatey.org/packages/terraform) if you have Windows) to automate the installation process.

Verify that your Terraform installation has been performed successfully and that your `PATH` has been set correctly by running the `terraform` command.

You should get the following output:
```
Usage: terraform [-version] [-help] <command> [args] 
(...)
```

><i> For further help on installing Terraform on your operating system, please visit Terraform's [Getting Started](https://learn.hashicorp.com/terraform/getting-started/install.html) guide. </i>


## Clone the Repository
Clone this repository on your machine to have all the necessary files needed to easily deploy a server with GPU support.

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
As a default, it has been assumed that a project has not been created, so the following block of code in `packet-gpu.tf` creates the `packet_project` resource:

```
resource "packet_project" "your_project_name" {
    name = "Your Project Name"
}
```
Your project name has been defaulted to `tf_project` and the description name has been defaulted to `New Project`, but you may customize it accordingly.

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
If you have already created a project in your Packet account and would like to use it, first enter `variables.tf`.

Enter your project ID in the `default` field. Your project ID can be found by going into your preferred project, and taking the portion of text after `https://app.packet.net/projects/<YOUR_PROJECT_ID>`.

```
variable "project_id" {
    (...)
    default = "<YOUR_PROJECT_ID_HERE>"
}
```

Then, head into the `packet-gpu.tf` file. Comment out `project_id = "${packet_project.tf_project.id}"`, and uncomment `project_id = "${var.project_id}"`:
```
resource "packet_device" "tf-gpu" {
    project_id            = "${var.project_id}"
    # project_id          = "${packet_project.tf_project.id}"
(...)
```

Also, comment out the block of code that creates a `packet_project` resource:
```
# resource "packet_project" "your_project_name" {
#     name = "Your Project Name"
# }
```

<i> After you are done, please continue to the section below. </i>

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


<b>IMPORTANT NOTE:<i> Please keep in mind that the continuous creation and deletion of projects will result in larger fines.</i></b> To prevent this, please run `terraform apply -target=module.tf-gpu`* to create more devices or update them without adding more to your bill!

><i>*Targetting modules allows projects to be re-used when you add, remove,or recycle GPU nodes. Please visit Terraform's documentation on [modules](https://www.terraform.io/docs/configuration/modules.html) for more information.</i>

## Enter Your Server
Open up a terminal, and SSH into your device. You may do this by entering:
```
ssh -L 8888:localhost:8888 user@PUBLIC_IPv4_ADDRESS
```

The IP address of your server can be found by logging into your Packet account and checking there, or by searching the `terraform.tfstate` file that has just been created after running `terraform apply`. 

Once there, please create a passphrase to secure your server.

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
Completed. Script finished.
```
at the bottom of the `cloud-init-output` log, the script has been completed.


## Create a Jupyter Notebook Without A Domain Name
To check your installations, install necessary packages, and create an insecure Jupyter notebook without a domain name in a Conda environment, run these commands: 

```
$ wget -O http-jupyter.sh https://raw.githubusercontent.com/tchan2/packet-gpu/master/scripts/without-domain.sh

$ chmod +x http-jupyter.sh

$ ./http-jupyter.sh
```

If you have left the script as the defaults, this will test your installations and make sure that they have installed correctly, create and activate an GPU-supported Anaconda environment called `jupyter_env`, and create a Jupyter notebook!

Once this runs, you will see a link like the following that you can use to access your Jupyter notebook:

```
[C 16:21:28.754 NotebookApp] 
(...)
    Or copy and paste one of these URLs:
        http://localhost:8888/?token=<YOUR-PERSONALIZED-TOKEN>

```
Just copy and paste this link into your preferred browser, and begin coding!

<br />

## Create a SSL-Enabled Jupyter Notebook With Domain Name
To check your installations, install necessary packages, and run a SSL-enabled Jupyter Notebook with a domain name, please follow the following instructions.

<b>Note</b>: This guide will focus on using [No-IP](https://no-ip.com) to create a domain name.

> If you do not wish to use No-IP and are using another site or have already created a domain name, please make sure your IP address has been set correctly, and then skip to [Run Script](#run-script).

### Sign Up 
Please go on [no-ip.com](https://no-ip.com) to create a free domain name! Sign up using your preferred email, and fill out any necessary fields.

### Create a Hostname
In order to create a hostname, please refer to the sidebar to the left.

Click on <i>`My Services`</i>, and then click on <i>`DNS Records`</i>. You will see a button that says <b><i>`Add a Hostname`</i></b>.

> If you would like to pay for a domain with no-ip.com, you may click on <b><i>`Domain Registration`</i></b>! 

Please set your hostname, and your preferred domain.

Then, for the <i>`Hostname Type`</i>, please set it to <i> `DNS Hostname (A)`</i>. 

### Set your IP Address
After you have created your domain name, please insert your public IPv4 address into the IP Address field.

### Add your Hostname
Click on <i> `Add Hostname` </i> and you have successfully created your domain name!

Please allow at least 5-10 minutes for this change to take place.

### Run Script
Run the following to get my script onto your Packet server to be able to enable SSL wrapping for your domain, and to add that domain name to your Jupyter notebook!
```
$ wget -O https-jupyter.sh https://raw.githubusercontent.com/tchan2/packet-gpu/master/scripts/with-domain.sh

$ chmod +x https-jupyter.sh
```

Now, pass your domain name and your email as the two arguments for the script to run it:
```
$ ./https-jupyter.sh your.domain.name your@email.com
```

### Access Your Jupyter Notebook
Now, your Jupyter notebook should have started running! You should see this: 

```
(...)
[I 21:16:06.647 NotebookApp] The Jupyter Notebook is running at:
[I 21:16:06.647 NotebookApp] https://your.domain.name/
(...)
```

Please follow the link provided, enter your password, and start coding!

## Acknowledgments
Special thanks to [My](https://github.com/truongmd), [Zak](https://github.com/zalkar-z) and, [Joseph](https://github.com/jmarhee) for all the help on this product!