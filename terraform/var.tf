
# YC account

variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}
variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}
variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

# YC zones

variable "default_region" {
  type        = string
  default     = "ru-central1"
}
variable "vms_zone" {
  type        = string
  default     = "standard-v1"
}
variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
}

# VPC

variable "network_name" {
  type = string
  default = "network"
}
variable "public" {
   type = map(any)
   default = {
      sub-a = {
         name = "public-a"
         zone = "ru-central1-a"
         cidr = "10.0.1.0/24"
      }
      sub-b = {
         name = "public-b"
         zone = "ru-central1-b"
         cidr = "10.0.2.0/24"
      }
      sub-d = {
         name = "public-d"
         zone = "ru-central1-d"
         cidr = "10.0.3.0/24"
      }
   }
}

# Ig VM

variable "ig_vm" {
  type = list(object({ 
    name       = string,
    p_id       = string,
    cpu        = number, 
    ram        = number, 
    disk       = number,
    cf         = number,
    type       = string,
    nat        = bool,
    sched_pol  = bool,
    fix_size   = number,
    dep_un     = number,
    dep_create = number,
    dep_exp    = number,
    dep_del    = number
    }))
  default = [ 
    {
    name       = "master"
    p_id       = "standard-v2"
    cpu        = 2
    ram        = 4
    disk       = 20
    cf         = 5
    type       = "network-ssd"
    nat        = true
    sched_pol  = true
    fix_size   = 3
    dep_un     = 3
    dep_create = 3
    dep_exp    = 3
    dep_del    = 3
    },
    {
    name       = "worker"
    p_id       = "standard-v2"
    cpu        = 2
    ram        = 2
    disk       = 20
    cf         = 5
    type       = "network-hdd"
    nat        = true
    sched_pol  = true
    fix_size   = 2
    dep_un     = 2
    dep_create = 2
    dep_exp    = 2
    dep_del    = 2    
    },
    {
    name       = "ingress"
    p_id       = "standard-v2"
    cpu        = 2
    ram        = 2
    disk       = 20
    cf         = 5
    type       = "network-hdd"
    nat        = true
    sched_pol  = true
    fix_size   = 2
    dep_un     = 2
    dep_create = 2
    dep_exp    = 2
    dep_del    = 2    
    }
  ]
  description = "ig resources"
}
variable "vm_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "yandex_compute_image_family"
}

# NLB set

variable "nlb_set" {
  type        = list(object({ 
    nlb_name  = string,
    app_list_name = string, 
    app_port  = number, 
    app_tport = number,
    mon_list_name = string,
    mon_port  = number,
    mon_tport = number,
    hc_name   = string
    }))
  default     = [ 
    {
    nlb_name  = "nlb-app"
    app_list_name = "listener-app" 
    app_port  = 80
    app_tport = 30001
    mon_list_name = "listener-grafana"
    mon_port  = 3000
    mon_tport = 30000
    hc_name   = "tcp"
    }
  ]
  description = "nlb settings"
}

# RS set

variable "rs" {
    type  = list(object({ 
    name  = string,
    type  = string, 
    ttl   = number
    }))
  default = [ 
    {
    name  = "app.bosone.ru."
    type  = "A" 
    ttl   = 200
    }
  ]
  description    = "rs settings"
}
variable "bosone_id" {
  type        = string
  default     = "dns7l9gn3jfmq8psoskj"
  description = "bosone.ru."
}