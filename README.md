# packet-gpu
A first step example of creating an environment that allows for the implementation of deep learning in a GPU supported Ubuntu Packet server using Terraform.

## Before You Begin
This guide was created for users who may not have Linux machines with GPU supported drivers, or want to engage in machine learning research with the use of bare metal servers. We will be using a [GPU accelerated Packet server](https://www.packet.com/cloud/) to implement a machine learning environment, which will require an hourly billing fee.

Please keep in mind that the device created will have Ubuntu 16.04 as the operating system and several packages and installations will be installed automatically. It will be helpful to have prior knowledge in Linux commands and the following installations, but you may install other applications to aid you in your machine learning research as desired:

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

<i> For further help on installing Terraform on your operating system, please visit Terraform's [Getting Started](https://learn.hashicorp.com/terraform/getting-started/install.html) guide. </i>

## Clone the Repository
Clone this repository to have all the necessary files needed to easily deploy a server with GPU support.

This can be done by entering the following: 
```
$ git clone https://github.com/tchan2/packet-gpu
```

Now you should have all the necessary files for deploying a Packet server with GPU acceleration.

## Create a Project 

If you already have a project created, you may go to the [Initializing Terraform](##initialize-terraform) section to begin initializing terraform for deployment.

If you do not already have a project created in Packet, one can easily be created by adding the following into the `packet-gpu.tf` file:

```
resource "packet_project" "your_project_name" {
    name = "Your Project Name"
}
```

and changing the following: 
```
resource "packet_device" "tf-gpu" {
    (...)
    # project_id = "${packet_project.your_project_name.id}"
}
```
<i> Please visit the section on [packet_project](https://www.terraform.io/docs/providers/packet/r/project.html) on the Terraform Packet Provider page for more help. </i>

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

Once this command has performed, please insert your authentication token (or your API key) and if prompted, your project ID accordingly.

If all the steps have been completed successfully, a Packet server will have been deployed!

## Enter Your Server
Open up a terminal, and SSH into your device. You may do this by entering:
```
ssh -L 8888:localhost:8888 root@PUBLIC_IPv4_ADDRESS
```

The IP address of your server can be found by logging into your Packet account and checking there, or by searching the `terraform.tfstate` file that has just been created after running `terraform apply`. 

Once there, please create a passphrase to secure your server.

## Check The Script
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
at the bottom of this script, the script has been completed.

## Check Your Installations
To ensure that all installations have been completed successfully, we must run the following the initialize our session after entering our server:
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
Mon Jan 01 01:01:01 2019  // Should show your own timestamp here      +-----------------------------------------------------------------------------+
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

Run the following command* to create a separate environment in Conda. Name it however you like.
```
$ conda create --name your_env_name python=3.7
```

Now, activate this environment.
```
$ conda activate your_env_name
```

Install Tensorflow-GPU and Jupyter.
```
$ pip install tensorflow-gpu
$ pip install jupyter
```

Now, you are ready to run your Jupyter notebook!
```
$ jupyter notebook --allow-root
```

Once this runs, you will see a link that you can enter into your browser to access your Jupyter notebook!

Happy coding!
