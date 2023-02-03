# Example for deploy control-plane to Amazon ECS

## Architectue

!(assets/control-plane-on-aws.jpg)

## Prepare
1. Make a s3 bucket for terraform backend
Write bucket name to `00-main.tf`
```
terraform {
  backend "s3" {
    bucket  = "example-pipecd-control-plane-tfstate" #your bucket name for terraform backend
    region  = "ap-northeast-1"
    key     = "tfstate"
    profile = "pipecd-control-planeg-terraform" #your profile
  }
  required_providers {
    aws = {
      version = "~> 3.34.0"
    }
  }
}
```

2. Edit `variables.tf` for your project
```
//export
locals {
  alb = {
    certificate_arn = ""
  }
  
  redis = {
    node_type = "cache.t2.micro"
  }

  rds = {
    node_type = "db.t3.micro"
  }

  ecs = {
    memory = "1024"
    cpu = "512"
  }
}
```

3. Make a s3 bucket for filestore and write the bucket name for it to `control-plane-config.yaml` and `variables.tf`
```
apiVersion: "pipecd.dev/v1beta1"
kind: ControlPlane
spec:
    datastore:
    type: MYSQL
    config:
        url: root:test@tcp(pipecd-mysql:3306)
        database: quickstart
    filestore:
    type: S3
    config: # edit here
        bucket: example-pipecd-control-plane-filestore 
        region: ap-northeast-1
    projects:
    - id: quickstart
        staticAdmin:
        username: hello-pipecd
        passwordHash: "$2a$10$ye96mUqUqTnjUqgwQJbJzel/LJibRhUnmzyypACkvrTSnQpVFZ7qK" # bcrypt value of "hello-pipecd"
```
```
//export
locals {
  s3 = { # These must be unique in the world.
    filestore_bucket = "${local.project}-filestore" # edit here
  }
}
```
4. Write config of RDS for datastore to `control-plane-config.yaml`
Note: Do not edit hostname (pipecd-mysql) because it will be edited autimaticaly by terraform.
```
apiVersion: "pipecd.dev/v1beta1"
kind: ControlPlane
spec:
    datastore:
    type: MYSQL
    config: # edit here
        url: root:test@tcp(pipecd-mysql:3306)
        database: quickstart
    filestore:
    type: S3
    config: 
        bucket: example-pipecd-control-plane-filestore 
        region: ap-northeast-1
    projects:
    - id: quickstart
        staticAdmin:
        username: hello-pipecd
        passwordHash: "$2a$10$ye96mUqUqTnjUqgwQJbJzel/LJibRhUnmzyypACkvrTSnQpVFZ7qK" # bcrypt value of "hello-pipecd"
```

5. Put encryption key and config file in secretsmanager and write the path to `variables.tf`
```
locals {
  sm = {
    control_plane_config_secret = ""
    envoy_config_secret         = ""
    encryption_key_secret       = ""
  }
}
```

## Deploy
```
terraform apply
```

## login admin console
You can login pipecd-ops via ecs-exec
```
aws ssm start-session --target ecs:${CLUSTER}_${TASK_ID}_${CONTAINER_ID} --document-name AWS-StartPortForwardingSession --parameters '{"portNumber":["9090"],"localPortNumber":["18080"]}'
```

