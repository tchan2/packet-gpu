# packet-gpu
A first step example of creating an environment that allows for the implementation of deep learning in a GPU supported Packet server using Terraform.

## Getting Started
Begin by [installing Terraform](https://www.terraform.io/downloads.html) on your machine. Please ensure that you download the file with the correct operating system and architecture of the machine you will be using Terraform on.

Verify that your Terraform installation has been performed successfully and that your `PATH` has been set correctly by running the `terraform` command.

You should get the following output:
```
Usage: terraform [-version] [-help] <command> [args] 
(...)
```

<i> For further help on installing Terraform on your operating system, please visit Terraform's [Getting Started](https://learn.hashicorp.com/terraform/getting-started/install.html). </i>

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

## Install Tensorflow
Finally, we are now able to use our Packet server to open up Jupyter and use it for machine learning!

Run the following command* to create a separate environment in Conda. Name it however you like.
```
$ conda create --name your_env_name python=3.7
```
<i>*<b>Reminder</b>: If the command does not work, it may be due to the fact that the script being run in your server has not finished yet. Please wait a couple of minutes after your server has been deployed before trying again. </i>


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
