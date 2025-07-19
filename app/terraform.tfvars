# EKS Cluster Configuration
aws_region      = "us-east-2"
cluster_name    = "cap-eks-cluster"
cluster_version = "1.32"

# VPC Configuration
vpc_cidr             = "10.0.0.0/16"
availability_zones   = ["us-east-2a", "us-east-2b"]
private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnet_cidrs  = ["10.0.101.0/24", "10.0.102.0/24"]

# Kubernetes Service IP Range
service_ipv4_cidr = "10.100.0.0/16"

# Cluster Logging
enable_cluster_logging = true
log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

# Node Groups Configuration
node_groups = {
  nodegroup-1 = {
    instance_types    = ["t3.medium"]
    capacity_type     = "SPOT"
    min_size         = 2
    max_size         = 4
    desired_size     = 2
    volume_encrypted = true
    ami_type         = "AL2_x86_64"
    disk_size        = 20
  }
}

# Fargate Profiles Configuration
fargate_profiles = {
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

# EKS Addons Configuration
addons = {
  vpc-cni = {
    version = "latest"
    configuration_values = {
      env = {
        ENABLE_PREFIX_DELEGATION            = "true"
        ENABLE_POD_ENI                      = "true"
        POD_SECURITY_GROUP_ENFORCING_MODE  = "standard"
      }
      enableNetworkPolicy = "true"
      nodeAgent = {
        enablePolicyEventLogs = "true"
      }
    }
    resolve_conflicts_on_create = "OVERWRITE"
    resolve_conflicts_on_update = "PRESERVE"
  }
  coredns = {
    version               = "latest"
    configuration_values = ""
    resolve_conflicts_on_create = "OVERWRITE"
    resolve_conflicts_on_update = "PRESERVE"
  }
  kube-proxy = {
    version               = "latest"
    configuration_values = ""
    resolve_conflicts_on_create = "OVERWRITE"
    resolve_conflicts_on_update = "PRESERVE"
  }
  aws-ebs-csi-driver = {
    version               = "latest"
    configuration_values = ""
    resolve_conflicts_on_create = "OVERWRITE"
    resolve_conflicts_on_update = "PRESERVE"
  }
  amazon-cloudwatch-observability = {
    version               = "latest"
    configuration_values = ""
    resolve_conflicts_on_create = "OVERWRITE"
    resolve_conflicts_on_update = "PRESERVE"
  }
}

# Service Accounts Configuration
service_accounts = {
  cluster-autoscaler-pa = {
    namespace = "kube-system"
    policies  = ["arn:aws:iam::aws:policy/AutoScalingFullAccess"]
  }
  aws-load-balancer-controller-pa = {
    namespace = "kube-system"
    policies  = ["arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"]
  }
}