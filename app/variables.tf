variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "pa-cap-eks-cluster"
}

variable "cluster_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.32"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "service_ipv4_cidr" {
  description = "CIDR block for Kubernetes service IPs"
  type        = string
  default     = "10.100.0.0/16"
}

variable "enable_cluster_logging" {
  description = "Enable EKS cluster logging"
  type        = bool
  default     = true
}

variable "log_types" {
  description = "List of log types to enable"
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "node_groups" {
  description = "Configuration for EKS node groups"
  type = map(object({
    instance_types     = list(string)
    capacity_type      = string
    min_size          = number
    max_size          = number
    desired_size      = number
    volume_encrypted  = bool
    ami_type          = string
    disk_size         = number
  }))
  default = {
    nodegroup-1 = {
      instance_types    = ["t3.medium"]
      capacity_type     = "SPOT"
      min_size         = 3
      max_size         = 6
      desired_size     = 3
      volume_encrypted = true
      ami_type         = "AL2_x86_64"
      disk_size        = 20
    }
  }
}

variable "fargate_profiles" {
  description = "Configuration for Fargate profiles"
  type = map(object({
    selectors = list(object({
      namespace = string
      labels    = map(string)
    }))
  }))
  default = {
    on-fargate = {
      selectors = [
        {
          namespace = "on-fargat"
          labels    = {}
        }
      ]
    }
    myprofile = {
      selectors = [
        {
          namespace = "prod"
          labels = {
            stack = "frontend"
          }
        }
      ]
    }
  }
}

variable "addons" {
  description = "EKS addons configuration"
  type = map(object({
    version               = string
    configuration_values = string
    resolve_conflicts    = string
  }))
  default = {
    vpc-cni = {
      version = "latest"
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION        = "true"
          ENABLE_POD_ENI                 = "true"
          POD_SECURITY_GROUP_ENFORCING_MODE = "standard"
        }
        enableNetworkPolicy = "true"
        nodeAgent = {
          enablePolicyEventLogs = "true"
        }
      })
      resolve_conflicts = "OVERWRITE"
    }
    coredns = {
      version               = "latest"
      configuration_values = ""
      resolve_conflicts    = "OVERWRITE"
    }
    kube-proxy = {
      version               = "latest"
      configuration_values = ""
      resolve_conflicts    = "OVERWRITE"
    }
    aws-ebs-csi-driver = {
      version               = "latest"
      configuration_values = ""
      resolve_conflicts    = "OVERWRITE"
    }
    amazon-cloudwatch-observability = {
      version               = "latest"
      configuration_values = ""
      resolve_conflicts    = "OVERWRITE"
    }
  }
}

variable "service_accounts" {
  description = "Service accounts with IAM roles"
  type = map(object({
    namespace = string
    policies  = list(string)
  }))
  default = {
    cluster-autoscaler-pa = {
      namespace = "kube-system"
      policies  = ["arn:aws:iam::aws:policy/AutoScalingFullAccess"]
    }
    aws-load-balancer-controller-pa = {
      namespace = "kube-system"
      policies  = ["arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"]
    }
  }
}