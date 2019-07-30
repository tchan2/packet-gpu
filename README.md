# packet-gpu
A first step example of creating an environment that allows for the implementation of deep learning in a GPU supported Ubuntu Packet server using Terraform.


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
#### If you do not have a project...
<i> Please skip to the [Create a Project](#create-a-project) section of this page. </i>

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

<i> You may now skip to the [Initialize Terraform](#initialize-terraform) section of this page. </i>


## Create a Project 
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
><i> Please visit the section on [packet_project](https://www.terraform.io/docs/providers/packet/r/project.html) on the Terraform Packet Provider page for more information of other fields you can add to customize your Packet project even further! </i>


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


## Create Jupyter Notebook
<!-- WORK IN PROGRESS -->
To create a Jupyter notebook and run it in a Conda environment all in one, run these commands: 

```
$ wget -O https://raw.githubusercontent.com/tchan2/packet-gpu/master/postinstall.sh

$ chmod +x postinstall.sh

$ ./postinstall.sh
```

This will test your installations and make sure that they have installed correctly, create and activate an GPU-supported Anaconda environment, and create a Jupyter notebook!

<!-- WORK IN PROGRESS -->

Once this runs, you will see a link that you can enter into your browser to access your Jupyter notebook!

Happy coding!

<!-- ## Check Your Installations
To ensure that all installations have been completed successfully, we must run the following to initialize our session after entering our server:
```
$ source ~/.bashrc
```

Now, please check if the following commands return the correct information.

```
$ conda
usage: conda [-h] [-V] command ...
(...)

$ nvidia-docker

Usage: docker [OPTIONS] COMMAND
(...)

$ nvcc -V
nvcc: NVIDIA (R) Cuda compiler driver
Copyright (c) 2005-2019 NVIDIA Corporation
(...)

$ nvidia-smi
Mon Jan 01 01:01:01 2019  // Should show your own timestamp here
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 418.67       Driver Version: 418.67       CUDA Version: 10.1     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  Tesla V100-SXM2...  Off  | 00000000:62:00.0 Off |                    0 |
| N/A   48C    P0    57W / 300W |      0MiB / 32480MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+
(...)
```


## Install Tensorflow
Finally, we are now able to use our Packet server to open up Jupyter and use it for machine learning!

Run the following command to create a separate environment in Conda. Name it however you like.
```
$ conda create --name juypter_env python=3.7
```

Now, activate this environment.
```
$ conda activate juypter_env
```

Install Tensorflow-GPU and Jupyter.
```
$ pip install tensorflow-gpu
$ pip install jupyter
$ pip install keras
```

Now, you are ready to run your Jupyter notebook!
```
$ jupyter notebook --allow-root
``` -->
