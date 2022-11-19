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



