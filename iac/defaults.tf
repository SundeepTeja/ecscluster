/* DEFAULT VARIABLES */
locals {
  tags = {
  Project = "assignment"
  Environ = "dev"
  Product = "ecscluster"                          
  Contact = "polinateja.sandeep@gmail.com"                    
   }
}

locals {
  meta = {
      name_prefix = "test-dev-assignment"
      region_name = "us-east-1"
      account_id = "1234567890"
   }
}