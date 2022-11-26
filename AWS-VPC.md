## VPC

### VPC creation primary steps
1. Create a Plain VPC and assign CIDR(Classless Inter Doman Routing) block. First determine the CIDR block ranges(number of IPs required under this VPC) based on the number of instances allocation with in the VPC. And make sure the CIDR blocks is not used within the organisation because in case if there is a requirement to peer 2 PVC then there will be a IP overlapping. 
2. Create a 2 or more subnets are per the requirement and name them as your wish but for better indentification name it Public/Private depends upon the allocations and allocate a AZ, portion of IPs from VPC CIDR block. 
