region      = "us-east-1"
environment = "dev"
bucket_name = ""

# ALB 
# certificate for alb listener
certificate_arn = ""
# path to get for the health check
lb_health_check_path = "/"
#lb_health_check_path = "/api/v1/scoreboard"

# ECR
ecr_name     = "ctf"
image_tag    = "latest"
network_mode = "awsvpc"
# Make sure these adhere to fargate requirements
# for now these are for the entire task, 2 containers
container_memory = 4096
container_cpu    = 2048

essential = true
# When this parameter is true, the container is given read-only access to its root file system.
readonly_root_filesystem = false

container_environment = [
  {
    name  = "ENVIRONMENT"
    value = "dev"
  },
  {
    name  = "REVERSE_PROXY"
    value = "true"
  },
  {
    name  = "ACCESS_LOG"
    value = "-"
  },
  {
    name  = "WORKERS"
    value = "1"
  },
  {
    name  = "INFARGATE"
    value = "true"
  },
  {
    name  = "ERROR_LOG"
    value = "-"
  }

]

port_mappings = [
  {
    containerPort = 8000
    protocol      = "tcp"
  }
]

######
# nginx
#######
# Make sure these adhere to fargate requirements
nginx_container_memory = 2048
nginx_container_cpu    = 1024

# When this parameter is true, the container is given read-only access to its root file system.
nginx_readonly_root_filesystem = false

nginx_container_environment = [
  {
    name  = "ENVIRONMENT"
    value = "dev"
  }
]

nginx_port_mappings = [
  {
    containerPort = 80
    protocol      = "tcp"
  }
]