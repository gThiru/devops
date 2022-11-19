# IAAC
## Types of IAC tools
### IAC tools classified into 3 types
1. Configuration management tools
  - Ansible
  - Puppet
  - Saltstack
    
    These tools commonly used to,
    - Install and manage softwares
    - Maintains standard structure
    - Designed to run on multiple resource(hosts) on simultenuesly 
    - Version control
    - Idempotent
        - It means, you can run same script multiple times in the same environment but it will apply only the changes new to the infra.
2. Server Templating
  - Docker
  - Hashicorp Packer
  - Hashicorp Vagrant
    
    These tools used to creare a custom images or virtual machines images which includes,
    - Pre installed softwares and tools
    - Which eliminates the dependencies while deploying application
    - These are immutable infrastructure where you can't do any change after deploying it, incase if you want to changes it then you have to update the image ans redeploy it
3. Infrastructure provissioning tools
  - Terraform
  - AWS Cloudformation template
  
    These toolse used to provissioning infrastructre using simple declarative code 
    - This infra varies from VMs, VPC, SG, network components, etc
    - Cloudformation - indentent to provission only in AWS environment
    - Terraform
        - Cloud agnostic and allows a single configuration to manage multiple providers and handle cross-cloud dependencies.

### Providers
Providers is a plugin that enables intraction with an APIs. These includes cloud providers and SaaS providers. The providers are specified in terraform configuration files. They tell Terraform which services it need to intract with.


### What does Declarative code means?
The code we define is the state we want our infrastrure to be in, that's the desire state. 
Terraform will take care of from current state to desire state. 

This is achieved in 3 state,
- Init  
    This phase terraform initialise the projects and identifies the providers to be used for the target environment  
    - terraform init  
        This command does the following actions
        - Checks the configuration files
        - Initialise the working directory containing the .terraform directory
        - Downloads and install the specified plugins into it
- Plan  
    This phase terraform draws the plan to get the target state  
    Output of this you can review the execution plan  
    - terraform plan 
      This dispays the execution plan carried out by **terraform apply** command  
      But this will not create any resource but it just shows the blue print of the execution
- Apply  
    This phase terraform makes the necessary changes required on the target environment to bring it to the desire state  
    - terraform apply  
      This command will show the execution plan once again and asks user to give a confirmation to proceed for the resource creation

### Hashicorp Configuration Language(HCL) configuration file resources
![Screenshot 2022-11-19 at 10 04 29](https://user-images.githubusercontent.com/20988358/202834231-47137da1-ce99-410c-8777-5a83c95c20be.png)

### Providers documentation
https://registry.terraform.io/browse/providers
### local_file documentation example
https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file

## Terraform commands
1. terraform init - Initialise the configuration
2. terraform plan - Creates the execution plan
3. terraform apply - Executes the configuration resources
4. terraform show - Show the resource details by inspecting state file
5. 
6. 


