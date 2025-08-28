bucket         = "tfstate-aws-infra-priscilla"
key            = "dev/network/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "tf-state-locks"
encrypt        = true
