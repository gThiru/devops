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

### Types of files
* main.tf -- Main configuration file containing resource definition
* variable.tf -- Contains variable declaration
* outputs.tf -- Contains output from resources
* provider.tf -- Contains providers definition

### Hashicorp Configuration Language(HCL) configuration file resources
![Screenshot 2022-11-19 at 10 04 29](https://user-images.githubusercontent.com/20988358/202834231-47137da1-ce99-410c-8777-5a83c95c20be.png)

### Block Names
* resource 
* variable

## Variables
Terraform follows many ways to declare and reuse of variables.
Example:
```terraform
Block example: variables.tf
variable "fruit" {
  default = "apple"
  type = string  # Optional but good to enforce the type of variable to be declared
  description = "Description about the variables" # Optional but it gives a additional information about variable
  taste = "sweet"
}

Usage example: in main configuration file
fruitName = var.fruit  # gets the default value(apple)
fruitTaste = var.fruit.taste # gets the 'sweet'
```
#### Ways of variable declaration methods, order of loading variable and precedence 
1. Environment variables --> export TF_VAR_carmodel="Rapid" -- reference this as *var.carmodel*
2. filename.tfvars or filename.tfvars.json --> carmodel="Rapid"
3. \*.auto.tfvars or \*.auto.tfvars.json(file name in alphabetical order) --> carmodel="Rapid"
4. Command line args --> -var or -var-file 
```terraform
# Command line args
terraform apply -var "carmodel=Rapid" -var "carcolor=Red"
# Varibale files as a args
terraform apply -var-file variables.tfvars
```

Variable loading and precedence goes top to bottom so Env vars loads first and ends with cmd line args and if the same variable used everywhere then command line value taken into the execution

#### How to pass keyboard inputs?
```terraform
variables.tf:

variable "car" {
      # Empty declarations makes program to ask the input while running
}

main.tf:

resource "local_file" "carMaker"{
  carModel = var.car # Which will prompt while executing because variable definition is blank in variable.tf file
}
```

#### Variable types
- string -- Alpha characters(a-z0-9) 
- number -- 123
- bool -- true / false
- any -- any values / default value
- list -- ["a","b","c"] -- index starts with 0 --> var.variable[0]
    - List of type  
    type = list(string) ==> Accepts only strings -- ["a","b"]  
    type = list(number) ==> Accepts only numbers -- [1,2,3]  
- map -- key value pairs -- fruit = {"color" = "red", "taste" = "sweet"} --> var.fruit["color"]
    - map types
      type = map(string) ==> Accepts values only string -- fruit = {"color" = "red", "taste" = "sweet"}
      type = map(number) ==> Accepts values only number -- fruit = {"count" = 100, "types" = 5}
- set -- [1,2,3] -- set is similar to list but it will not accept the duplicate entries like [1,2,3,3] <== wrong declaration  
    - map of type  
    type = map(string) ==> Accepts only strings -- ["a","b"]  
    type = map(number) ==> Accepts only numbers -- [1,2,3] 
- objects -- Can be used to create a complex variable structure by combining all above variable types
    - Example:
     type = object({
      name = string
      colors = list
      count = number
      is_it_favorite = bool
     }) 
- tuple - tuple([string, number, bool]) ==> [cat, 5, true]- Different type of variable can be combined together and it only accepts specified number of elements and same data type


### Providers documentation
https://registry.terraform.io/browse/providers
### local_file documentation example
https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file

## Terraform commands
1. terraform init - Initialise the configuration
2. terraform plan - Creates the execution plan
3. terraform apply - Executes the configuration resources
4. terraform show - Show the resource details by inspecting state file
5. terraform destroy - Deletes the all the resource in the current configuration
6. 
7. 


