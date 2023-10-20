# Terraform - One Tool to Rule Them All

>Automate your Infrastructure with Terraform

1. What is Terraform
    - Infrastructure as a code tool that helps you declare the configuration for your server deployment on any cloud platform or your on-premise infrastructure.
    - Terraform creates and manages resources on cloud platforms and other services through their application programming interfaces (APIs). Providers enable Terraform to work with virtually any platform or service with an accessible API.
    - Terraform makes use of HCL (HashiCorp Configuration Language) which is easy to understand

2. Why you need it
    - Infrastructure deployment includes a lot of factors related to server environment, incoming and outgoing network, user authentication and authorizations strategy.
    - One of the most crucial parts of the infrastructure is to maintain the steady state of the user configuration, lifecycle of the server and stability of your application deployed on those servers.
    - Terraform is used to automate infrastructure provisioning using reusable, shareable, human-readable configuration files. The tool can automate infrastructure provisioning in both on-premises and cloud environments.

3. How to you use Terraform

    1. Provider
        - Terraform relies on plugins called providers to interact with cloud providers, SaaS providers, and other APIs.
        - Providers are Terraform plugins that are used to interact with remote systems such as Docker, AWS, Azure…
        - Terraform has a huge list of providers. A complete list of providers can be found here.

    2. How to Use Providers
        - Providers are released separately from Terraform itself and have their own version numbers.

Implementing VMs and Containers can be a tedious task when you need to manage them on larger scale. Terraform is the best tool to automate the provisioning and deployment of such resources in an instant. It provides plan to deploy or destroy the infrastructure and helps you to efficiently maintain the resources based on their versions.

Today we will deep dive on how to use terraform tool more efficiently with Multiple providers at once for maintaining our hybrid infrastructure.

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