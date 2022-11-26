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

### Providers documentation
https://registry.terraform.io/browse/providers
### local_file documentation example
https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file

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

### Resource Dependencies
There are 2 types of dependencies,  
1. Implicit dependencies
2. Explicit dependencies

```
main.tf:

resource "local_file" "pet"{
  filename = var.filename
  content = "My favorite pet is Cat"
}

resource "random_pet" "my-pet"{
  prefix = var.prefix
  separator = var.separator
  length = var.length
}
```
**Implicit dependencies**
```
  content = "My favorite pet is ${random_pet.my-pet.id}"
```
===> ${random_pet.my-pet.id} -- it's called as a variable interpolation because of this reference terraform automatically creates the dependency with *my-pet* resource so order of creations,  
- First creates *my-pet*
- Then creates *pet*

But incasse of deletion it does in opposite direction 
- First deletes *pet*
- Then deletes *my-pet*

**Explicit dependencies**
```
  content = "My favorite pet is Cat"
  depends_on = [
    random_pet.my-pet
  ]
```
### Terraform State files
State file created only when *terraform apply* command executed. It stores the all the resource state and meta data information in it. It used to reference and commpare the running environment state vs applying new changes so based on the result it takes the actions like, applying new changes and creating a new ID and updating the same in state file, deleting the resources incase user deleted from source definition file, and finally it avoids the referencing in every terraform command to the resource providers and improves the performance.  

Terraform state file is the single source of truth what is applied on the real world environment.
### Output variables
Syntax format

```terraform
output "out_ref_name"{
  value = random_pet.my-pet.id # Mandatory field
  description = "My pet value" # Optional
}
```

Example of command output
```terraform
# Prints all the output values from the all configuration files in the current directory
terraform output
# Specific to a one variable
terraform output out_ref_name
```
#### Where we going to use of output variables
1. When you want to quickly display all the created resource
2. To feed an input to other configuration management tools such as Ansible and Shell scripts

## Terraform Lifecycle rules
Lifecycle rule is applied within the resource block itself

```terraform
resource "local_file" "myfile"{
  filename = "somefile"
  lifecycle {
    create_before_destroy = true
  }
}
```
1. *create_before_destroy = true* -> When there is a change in configuration file, terraform destryies the resource first and creates a new one so this rule will prevent the same and allows to create first and delete it
2. *prevent_destroy = true* - This will not allow to remove a resource even after creating it
3. *ignore_changes = [ tags, filename]* or *ignore_changes = all* - This will ignore applying the changes made outside of terraform on specified tags or all tags

## Data Sources
Data source can be provissioned outside of the terraform controls such as creating a file manually, script or creating a database manually and accessing them using data block.  

- Data block is similar to the *resource* block.  
- Here we are used *local_file* resource but it can be any valid terraform supported resource can be used to refer it.  
- Content can be reffered using the data keyword and mandatory fields for each resource can be refered in documentation.  
- Data resource can be used only for a read purpose.

```terraform
resource "local_file" "pet"{
  filename = var.filename
  content = data.local_file.dog.content # Data read from dog file
}

data "local_file" "dog" {
  filename = "/root/dog.txt"
}
```
## Loops
Two types of loop followed in terraform,
1. count
2. for-each

### count
Count is used to iterate with multiple items to loop it

```terraform
resource "local_file" "myfile" {
  filename = var.filename
  count = 3 # this will iterate 3 times of this block
  # OR
  filename = var.filename[count.index]
  count = length(var.filename) # This will give a length of filenames 
}

# variables.tf
variable "filename" {
  default = [
    "/root/dog.txt",
    "/root/cat.txt",
    "/root/hen.txt"
  ]
}
```
But *count* has a issue when we remove an element from list, like remove first element from list then other elements in list will be left shifted so when we hit the *terraform apply* command it will remove the third element(hen.txt) because as per the *count.index* 3rd element is not present so it destrying it, thats where *for-each* comes into the picture.  

### for-each
For-each solves the above indexing problem but it will not work in list function so you have to provide a map values to proceed

```terraform
resource "local_file" "myfile" {
  filename = each.value
  for_each = toset(var.filename) # This will give a key-value(map) output 
}

# variables.tf
variable "filename" {
  default = [
    "/root/dog.txt",
    "/root/cat.txt",
    "/root/hen.txt"
  ]
}
```
## Terraform providers versions
By default terraform downloads all providers in the latest version available so if you want to specify a specic version then we have to specify the same. 

At the top of the configuration file you have to specify the versions requirements

```terraform
terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "1.4.0" # specific version
      version = "> 1.4.0" # Greater then this version
      version = "!= 1.4.0" # Except this version
      version = "> 1.2.0, < 2.0.0, != 1.4.0" # This is enforces greater then 1.2.0 and less than 2.0.0 and not the 1.4.0
      version = "~> 1.2" # Which will download anything greater then 1.3, 1.4, 1.5, etc,.
      version = "~> 1.2.0" # Which will download anything greater then 1.2.1, 1.2.2, 1.2.3, ... 1.2.9
    }
  }
}
```

### Block Names
* resource 
* variable
* output
* data



## Terraform commands
1. terraform init - Initialise the configuration
2. terraform plan - Creates the execution plan
3. terraform apply - Executes the configuration resources
4. terraform show - Show the resource details by inspecting state file
5. terraform show -json - shows output in json format
6. terraform destroy - Deletes the all the resource in the current configuration
7. terraform output - Prints all the output values from the all configuration files in the current directory
8. terraform output *varibale name* - Specific to a one ouput variable
9. terraform plan --referesh=false - which will not refresh the state file instead it will use the local cache file to do the comparissions
10. terraform validate - To validate the configuration files
11. terraform fmt - Formates the configuration file as per the standard
12. terraform providers - To get all the providers used in the configurations
13. terraform providers mirror /path/to/the/new/location - this will copy all the providers to the new directory
14. terraform refresh - To sync with real world infrastructure, if any manual update made in infrastructure outside of terraform commands this will bring update the stat files
15. terraform graph - Graph for dependency and execution plan. Hard to see the graph in cmd prompt so install *graphviz* to see in visual using a *dot* command
16. terraform graph | dot -Tsvg > graph.svg  - which will create a visual graph of dependencies 

















