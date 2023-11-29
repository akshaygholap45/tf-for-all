# Terraform - One Tool to Rule Them All

>Automate your Infrastructure with Terraform

1. What is Terraform
    - Infrastructure as code tool that helps you declare the configuration for your server deployment on any cloud platform or your on-premise infrastructure.
    - Terraform creates and manages resources on cloud platforms and other services through their application programming interfaces (APIs). Providers enable Terraform to work with virtually any platform or service with an accessible API.
    - Terraform makes use of HCL (HashiCorp Configuration Language) which is easy to understand

2. Why you need it
    - Infrastructure deployment includes a lot of factors related to the server environment, incoming and outgoing network, user authentication and authorization strategy.
    - One of the most crucial parts of the infrastructure is to maintain the steady state of the user configuration, lifecycle of the server and stability of your application deployed on those servers.
    - Terraform is used to automate infrastructure provisioning using reusable, shareable, human-readable configuration files. The tool can automate infrastructure provisioning in both on-premises and cloud environments.

3. How do you use Terraform

    1. Provider
        - Terraform relies on plugins called providers to interact with cloud providers, SaaS providers, and other APIs.
        - Providers are Terraform plugins that are used to interact with remote systems such as Docker, AWS, Azure…
        - Terraform has a huge list of providers. A complete list of providers can be found here.

    2. How to Use Providers
        - Providers are released separately from Terraform itself and have their version numbers.
        - Implementing VMs and Containers can be a tedious task when you need to manage them on a larger scale. Terraform is the best tool to automate the provisioning and deployment of such resources in an instant. It provides a plan to deploy or destroy the infrastructure and helps you to efficiently maintain the resources based on their versions.

Today we will deep dive into how to use Terraform more efficiently with Multiple providers for maintaining our hybrid infrastructure.

## Phase 1: Generate API token for Terraform

1. Go to Proxmox Web UI. Select Datacenter and look for the 'API Token' tab.

2. Structure your variables to make use of this API token and Secret

    Token ID is User-defined. You can also create another user instead of root and include that user for token creation.

    API Token ID and Secret is a one-time thing, once it is generated it will not be available for the next time. So make sure you have copied it down before closing the Token window.

    ![Alt text](image-12.png)

    For now, I'm using the **.tfvar** file to store these credentials which is not a very secure way to deal with the secrets for your terraform configuration. You can make use of environment variables or use any password manager for the most secure way to handle the API token and credentials.

    Your .tfvar file should look like this:

    ```bash
    proxmox_api_url = "https://172.16.205.150:8006/api2/json"
    proxmox_api_token_id = "root@pam!terra-api"
    proxmox_api_token_secret = "ef95a8ab-d04a-4d1e-886e-3dbe2150bf5b"
    ```

    **[ Note: Never store your API token credentials on any git repository. This is just a testing project, it is not recommended to follow this approach for handling credentials in the production environment. ]**

## Phase 2: Installing Proxmox Provider

1. Proxmox doesn't have an official Terraform Provider, so we will be using the provider maintained by 'Telmate'.

    Link for Provider: `https://registry.terraform.io/providers/Telmate/proxmox/latest`

    A Terraform provider is responsible for understanding API interactions and exposing resources. The Proxmox provider uses the Proxmox API. This provider exposes two resources: proxmox_vm_qemu and proxmox_lxc.

2. Installation Steps:
    To install this provider, copy and paste this code into your Terraform configuration (include a version tag).

    ```hcl
    terraform {
    required_providers {
        proxmox = {
            source  = "telmate/proxmox"
            version = "<version tag>"
            }
        }
    }
    ```

    Here is the sample provider file example.

    ```hcl
    terraform {
    required_providers {
        proxmox = {
            source = "Telmate/proxmox"
            version = "2.9.14"
            }
        }
    }
    
    variable "proxmox_api_url" {
    type = string
    }


    variable "proxmox_api_token_id" {
    type = string
    sensitive = true    // Marking it as sensitive Terraform will not store this variable in its logs
    }

    variable "proxmox_api_token_secret" {
    type = string
    sensitive = true
    }

    provider "proxmox" {
    pm_api_url = var.proxmox_api_url
    pm_api_token_id = var.proxmox_api_token_id
    pm_api_token_secret = var.proxmox_api_token_secret
    pm_tls_insecure = true  // Necessary if you are not using ssl certificate

    }
    ```

    Then, run

    `$ terraform init`

    You should see the following marking the successful plugin installation:

    ```[...]
    Initializing provider plugins...
    - Finding registry.example.com/telmate/proxmox versions matching ">= 1.0.0"...
    - Installing registry.example.com/telmate/proxmox v1.0.0...
    - Installed registry.example.com/telmate/proxmox v1.0.0 (unauthenticated)

    Terraform has been successfully initialized!
    [...]
    ```

## Phase 3: Deploying the VM instance using Terraform

1. We will be using the template of the Ubuntu server created earlier. You can either use such a template or use an ISO file to create an instance.

2. Creating a terraform configuration file for the VM instance

    Your Terraform configuration file would look like this.

    ```hcl
    resource "proxmox_vm_qemu" "demo_node01" {
    target_node = "soc-pve-03"
    name = "ubuntu-pmx-01"
    desc = "Ubuntu Server Using Terraform Proxmox Provider"
    agent = 0

    clone = "debian12"
    cores = 1
    sockets = 1
    cpu = "host"
    memory = 2048

    network {
        bridge = "vmbr0"
        model = "virtio"
    }

    disk {
        storage = "HDD"
        type = "scsi"
        size = "15G"
    }

    }
    ```

3. Run `terraform plan`
   - This creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure.

4. Run `terraform apply`
    - Approve the plan using **yes** and it will execute the actions proposed in a Terraform plan to create the instance.

    ```bash
    Plan: 1 to add, 0 to change, 0 to destroy.

    Do you want to perform these actions?
    Terraform will perform the actions described above.
    Only 'yes' will be accepted to approve.

    Enter a value: yes

    proxmox_vm_qemu.demo_node01: Creating...
    proxmox_vm_qemu.demo_node01: Still creating... [10s elapsed]
    proxmox_vm_qemu.demo_node01: Still creating... [20s elapsed]
    proxmox_vm_qemu.demo_node01: Still creating... [30s elapsed]
    proxmox_vm_qemu.demo_node01: Still creating... [40s elapsed]
    proxmox_vm_qemu.demo_node01: Still creating... [50s elapsed]
    proxmox_vm_qemu.demo_node01: Creation complete after 51s [id=soc-pve-03/qemu/106]

    Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
    ```

    - Refer screenshot below showing the newly spawned VM (ubuntu-pmx-01) using the template "debian12" mentioned in the Terraform code.

    ![Alt text](image-13.png)

---

## AWS - Multi-tier Architecture

1. Which size, subnet, structure of VPC?
    /28 (16 IP) and /16 (65536 IP)

2. Reserve 2+ Networks per region being used per account
    ![Alt text](image.png)

3. VPC Sizing
    ![Alt text](image-1.png)

4. How many Subnets to use depending on AZ
    - If you have 4 AZ then you will need 4 subnets
    - 10.16 > 10.127
    - 10.16 (US1), 10.32.(US2), 10.48 (US3), 10.64 (EU), 10.80 (AU)
        ![Alt text](image-2.png)

5. VPC and Subnets
    - Architecture VPC setupGetAZs
        ![Alt text](image-4.png)
    - Limits
        ![Alt text](image-3.png)
    - DNS
        ![Alt text](image-5.png)

        [] Enable DNS resolution

        [] Enable DNS hostname

    You will end up with below architecture
    ![Alt text](image-6.png)

6. VPC Subnets
    - AZ Resilient
    - subset of a VPC CIDR
    - Free communication between subnets in same VPC
    - 5 reserved IPs per subnet
        ![Alt text](image-7.png)
    - Subnets 10.16.0.0/16
        NAME CIDR AZ CustomIPv6Value
        sn-reserved-A 10.16.0.0/20 AZA IPv6 00
        sn-db-A 10.16.16.0/20 AZA IPv6 01
        sn-app-A 10.16.32.0/20 AZA IPv6 02
        sn-web-A 10.16.48.0/20 AZA IPv6 03

        sn-reserved-B 10.16.64.0/20 AZB IPv6 04
        sn-db-B 10.16.80.0/20 AZB IPv6 05
        sn-app-B 10.16.96.0/20 AZB IPv6 06
        sn-web-B 10.16.112.0/20 AZB IPv6 07

        sn-reserved-C 10.16.128.0/20 AZC IPv6 08
        sn-db-C 10.16.144.0/20 AZC IPv6 09
        sn-app-C 10.16.160.0/20 AZC IPv6 0A
        sn-web-C 10.16.176.0/20 AZC IPv6 0B

        Remember to enable auto assign ipv6 on every subnet you create.

    - Enable auto Assign IPv6 settings for all subnets
        ![Alt text](image-8.png)

7. NAT Gateway
    - IP Masquerading: Many Private IPs to one single IP
    - Coz Public IPv4 running out
    - Gives outgoing only internet access
    - From public net to Private dint work
    - Deployment of NAT needs to run from Public Subnet as it needs to assign public IPv4 to itself.
    - AZ Resilient service, If entire AZ fails NAt gateway will fail, so need NAT GW in each AZ
    - Uses Elastic IP, also Scales up to 45Gbps
    **All IPv6 Addresses in AWS are publicly routable**

8. VPC Router
    - Main route table is used if not mentioned
    - Subnet only have one route-table but a route table can be associated with many subnets
    - Route table responsible for what happens to data as it leaves the subnet towards the destination

9. Internet Gateway
    - 1 VPC = 0 or 1 IGW, 1IGW = 0 or 1 VPC
    - Adding target as IGW makes subnet public
    - Add routes in route table for any IP point it to IGW
        ![Alt text](image-9.png)

10. ASG (Auto Scaling Group)
    ![Alt text](tur3_0209.png)
    - requires ami_image_id
    - security_group

11. AWS Load Balancer
    AWS offers three types of load balancers:

    - Application Load Balancer (ALB)
        Best suited for load balancing of HTTP and HTTPS traffic. Operates at the application layer (Layer 7) of the Open Systems Interconnection (OSI) model.

    - Network Load Balancer (NLB)
        Best suited for load balancing of TCP, UDP, and TLS traffic. Can scale up and down in response to load faster than the ALB (the NLB is designed to scale to tens of millions of requests per second). Operates at the transport layer (Layer 4) of the OSI model.

    - Classic Load Balancer (CLB)
        This is the “legacy” load balancer that predates both the ALB and NLB. It can handle HTTP, HTTPS, TCP, and TLS traffic but with far fewer features than either the ALB or NLB. Operates at both the application layer (L7) and transport layer (L4) of the OSI model.

    ALB Consists of several parts
    ![Alt text](tur3_0211.png)

11. Deploying a WebServer Cluster

    1. Create instance - aws_instance.example
        - ami
        - instance_type
        - vpc_security_group_ids (attaches security group for access control to instance)
        - tags (optional)
        - user_data (optional)

    2. Security group to expose port
        - name - aws_security_group.instance
        - ingress and egress
            - from and to port
            - cidr block
            - protocol
        Simply creating a security group isn’t enough; you need to tell the EC2 Instance to actually use it by passing the ID of the security group into the vpc_security​_group_ids argument of the aws_instance resource.

    3. Auto scaling (asg)
        The first step in creating an ASG is to create a launch configuration, which specifies how to configure each EC2 Instance in the ASG

        1. launch configuration (aws_launch_configuration)
            - image_id (same as ami_id)
            - instance_type
            - security group
            - lifecycle

        2. autoscaling group
            - map launch config
            - map vpc zone identifier = data.aws.subnets.defaults.ids
                - vpc_zone_identifier - get this data from provider if not configured for default vpc 

            - min & max size
            - tags
            - subnet_ids (extract this info from data source)
                It is needed to launch EC2 instance in particular subnet of VPC

        3. data
            - To get the data from Provider
            - data.aws_vpc: If set to default it gives data of default VPC
            - aws_subnet: Here we use filter data.aws_vpc.default.id to extract subnet info from data block

            Finally, you can pull the subnet IDs out of the aws_subnets data source and tell your ASG to use those subnets via the (somewhat oddly named) vpc_zone_identifier argument as data.aws_subnets.default.ids

    4. Load Balancer (aws_lb)
            We will be using ALB for HTTP traffic
            - name
            - load_balancer_type : ALB or NLB
            - subnets - map retrieved data.aws_subnets

        1. Listeners (aws_lb_listeners)
            - load_balancer_arn - mapping
            - port - number of port where it will listen
            - protocol - HTTP/HTTPS for ALB
            - default_action - 

        2. Security Grp for ALB
            - name - aws_security_group.alb
                - ingress
                - egress
            - map the security group to aws_lb.example

        3. Target groups for ASG
                - name - aws_lb_target_group.asg
                - port
                - protocol
                - vpc_id
                - health_check
                    - path
                    - protocol
                    - interval
                    - timeout
                    - healthy_threshold
                    - unhealthy_threshold

        4. target group mapping
            - map this in aws_autoscaling_group.example
                - target_group_arns = [aws_lb_target_group.asg.arn]
                - heath_check_type = "ELB"

        5. listener rule
            - listener arn =aws_lb_listener_rule.asg.arn
            - priority
            - condition
                - path_patterns
                    - values
            - action
                - type = forward
                - target_group_arn = aws_lb_target_group.asg.arn

Stage 2 - DB Addition

![Alt text](tur3_0309.png)


### Remote Backend


```bash
 ╭─akshay@thinkpad in repo: tf-for-all/global/s3 on  master [x!?] via 💠 default took 1s
 ╰─λ tf init -backend-config=backend.hcl -backend-config="access_key=$TF_VAR_aws_access_key" -backend-config="secret_key=$TF_VAR_aws_secret_key"

Initializing the backend...
Acquiring state lock. This may take a few moments...
Do you want to copy existing state to the new backend?
  Pre-existing state was found while migrating the previous "local" backend to the
  newly configured "s3" backend. No existing state was found in the newly
  configured "s3" backend. Do you want to copy this state to the new "s3"
  backend? Enter "yes" to copy and "no" to start with an empty state.

  Enter a value: yes

Releasing state lock. This may take a few moments...

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Reusing previous version of hashicorp/aws from the dependency lock file
- Using previously-installed hashicorp/aws v5.21.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

![Alt text](image-10.png)

Packer webserver snap

![Alt text](image-11.png)