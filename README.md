# Дипломный практикум в Yandex.Cloud
- [Дипломный практикум в Yandex.Cloud](#дипломный-практикум-в-yandexcloud)
  - [Цели:](#цели)
  - [Этапы выполнения:](#этапы-выполнения)
    - [Создание облачной инфраструктуры](#создание-облачной-инфраструктуры)
    - [Создание Kubernetes кластера](#создание-kubernetes-кластера)
    - [Создание тестового приложения](#создание-тестового-приложения)
    - [Подготовка cистемы мониторинга и деплой приложения](#подготовка-cистемы-мониторинга-и-деплой-приложения)
    - [Установка и настройка CI/CD](#установка-и-настройка-cicd)
  - [Что необходимо для сдачи задания?](#что-необходимо-для-сдачи-задания)

**Перед началом работы над дипломным заданием изучите [Инструкция по экономии облачных ресурсов](https://github.com/netology-code/devops-materials/blob/master/cloudwork.MD).**

---
## Цели:

1. Подготовить облачную инфраструктуру на базе облачного провайдера Яндекс.Облако.
2. Запустить и сконфигурировать Kubernetes кластер.
3. Установить и настроить систему мониторинга.
4. Настроить и автоматизировать сборку тестового приложения с использованием Docker-контейнеров.
5. Настроить CI для автоматической сборки и тестирования.
6. Настроить CD для автоматического развёртывания приложения.

---
## Этапы выполнения:


### Создание облачной инфраструктуры

Для начала необходимо подготовить облачную инфраструктуру в ЯО при помощи [Terraform](https://www.terraform.io/).

Особенности выполнения:

- Бюджет купона ограничен, что следует иметь в виду при проектировании инфраструктуры и использовании ресурсов;
Для облачного k8s используйте региональный мастер(неотказоустойчивый). Для self-hosted k8s минимизируйте ресурсы ВМ и долю ЦПУ. В обоих вариантах используйте прерываемые ВМ для worker nodes.
- Следует использовать версию [Terraform](https://www.terraform.io/) не старше 1.5.x .

Предварительная подготовка к установке и запуску Kubernetes кластера.

1. Создайте сервисный аккаунт, который будет в дальнейшем использоваться Terraform для работы с инфраструктурой с необходимыми и достаточными правами. Не стоит использовать права суперпользователя
2. Подготовьте [backend](https://www.terraform.io/docs/language/settings/backends/index.html) для Terraform:  
   а. Рекомендуемый вариант: S3 bucket в созданном ЯО аккаунте(создание бакета через TF)
   б. Альтернативный вариант:  [Terraform Cloud](https://app.terraform.io/)  
3. Создайте VPC с подсетями в разных зонах доступности.
4. Убедитесь, что теперь вы можете выполнить команды `terraform destroy` и `terraform apply` без дополнительных ручных действий.
5. В случае использования [Terraform Cloud](https://app.terraform.io/) в качестве [backend](https://www.terraform.io/docs/language/settings/backends/index.html) убедитесь, что применение изменений успешно проходит, используя web-интерфейс Terraform cloud.

Ожидаемые результаты:

1. Terraform сконфигурирован и создание инфраструктуры посредством Terraform возможно без дополнительных ручных действий.
2. Полученная конфигурация инфраструктуры является предварительной, поэтому в ходе дальнейшего выполнения задания возможны изменения.

[**S3**](terraform/s3/)

[main.tf](s3/main.tf)
[prov.tf](s3/prov.tf)
[var.tf](s3/var.tf)

**Предварительно создаём конфигурации сервисного аккаунта и S3-хранилища.**

<details>
    <summary>terraform plan</summary>

```terraform
root@devnet:/home/bosone/devops-diplom-yandexcloud/terraform/s3# terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  + create

Terraform will perform the following actions:

  # local_file.backend-key will be created
  + resource "local_file" "backend-key" {
      + content              = (sensitive value)
      + content_base64sha256 = (known after apply)
      + content_base64sha512 = (known after apply)
      + content_md5          = (known after apply)
      + content_sha1         = (known after apply)
      + content_sha256       = (known after apply)
      + content_sha512       = (known after apply)
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "../secret.backend.tfvars"
      + id                   = (known after apply)
    }

  # null_resource.key will be created
  + resource "null_resource" "key" {
      + id = (known after apply)
    }

  # yandex_iam_service_account.sa-tf will be created
  + resource "yandex_iam_service_account" "sa-tf" {
      + created_at = (known after apply)
      + folder_id  = (known after apply)
      + id         = (known after apply)
      + name       = "sa-tf"
    }

  # yandex_iam_service_account_static_access_key.sa-sa-key will be created
  + resource "yandex_iam_service_account_static_access_key" "sa-sa-key" {
      + access_key           = (known after apply)
      + created_at           = (known after apply)
      + description          = "access key for tf"
      + encrypted_secret_key = (known after apply)
      + id                   = (known after apply)
      + key_fingerprint      = (known after apply)
      + secret_key           = (sensitive value)
      + service_account_id   = (known after apply)
    }

  # yandex_resourcemanager_folder_iam_member.editor-tf will be created
  + resource "yandex_resourcemanager_folder_iam_member" "editor-tf" {
      + folder_id = "b1g6mhank6ep202dhg0g"
      + id        = (known after apply)
      + member    = (known after apply)
      + role      = "editor"
    }

  # yandex_storage_bucket.tfstate-diplom will be created
  + resource "yandex_storage_bucket" "tfstate-diplom" {
      + access_key            = (known after apply)
      + bucket                = "tfstate-diplom"
      + bucket_domain_name    = (known after apply)
      + default_storage_class = (known after apply)
      + folder_id             = (known after apply)
      + force_destroy         = true
      + id                    = (known after apply)
      + max_size              = 10000000
      + secret_key            = (sensitive value)
      + website_domain        = (known after apply)
      + website_endpoint      = (known after apply)

      + anonymous_access_flags {
          + list = false
          + read = false
        }
    }

Plan: 6 to add, 0 to change, 0 to destroy.

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run
"terraform apply" now.
```
</details>

**Применяем предварительную конфигурацию. Полученые файлы (конфигурация сервисного аккаунта - key.json, имя бакета с ключами доступа - secret.backend.tfvars) используем для создания инфраструктуры на следующем шаге.**

<p align="center">
    <img width="1200 height="600" src="/img/yc_web_s3.png">
</p>

<p align="center">
    <img width="1200 height="600" src="/img/yc_web_sa-tf.png">
</p>

**В основном разделе ининциализируем terraform с параметрами бекэнда - terraform init -backend-config=secret.backend.tfvars, добавим подсети в разных зонах, проверим:**

<details>
    <summary>terraform plan</summary>

```terraform
root@devnet:/home/bosone/devops-diplom-yandexcloud/terraform# terraform plan
data.template_file.cloudinit: Reading...
data.template_file.cloudinit: Read complete after 0s [id=48ea1a58580d2fc98a086c492fa5bd9c501dca4ae4ad9d8e6593353bb21bfb4e]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  + create

Terraform will perform the following actions:

  # yandex_vpc_network.network will be created
  + resource "yandex_vpc_network" "network" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "network"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.public["sub-a"] will be created
  + resource "yandex_vpc_subnet" "public" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "public-a"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.0.1.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

  # yandex_vpc_subnet.public["sub-b"] will be created
  + resource "yandex_vpc_subnet" "public" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "public-b"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.0.2.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-b"
    }

  # yandex_vpc_subnet.public["sub-c"] will be created
  + resource "yandex_vpc_subnet" "public" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "public-c"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.0.3.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-c"
    }

Plan: 4 to add, 0 to change, 0 to destroy.

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run
"terraform apply" now.
```
</details>

<p align="center">
    <img width="1200 height="600" src="/img/ter_apply_1.png">
</p>

<p align="center">
    <img width="1200 height="600" src="/img/ter_destroy_1.png">
</p>

<p align="center">
    <img width="1200 height="600" src="/img/s3_state.png">
</p>


### Создание Kubernetes кластера

На этом этапе необходимо создать [Kubernetes](https://kubernetes.io/ru/docs/concepts/overview/what-is-kubernetes/) кластер на базе предварительно созданной инфраструктуры.   Требуется обеспечить доступ к ресурсам из Интернета.

Это можно сделать двумя способами:

1. Рекомендуемый вариант: самостоятельная установка Kubernetes кластера.  
   а. При помощи Terraform подготовить как минимум 3 виртуальных машины Compute Cloud для создания Kubernetes-кластера. Тип виртуальной машины следует выбрать самостоятельно с учётом требовании к производительности и стоимости. Если в дальнейшем поймете, что необходимо сменить тип инстанса, используйте Terraform для внесения изменений.  
   б. Подготовить [ansible](https://www.ansible.com/) конфигурации, можно воспользоваться, например [Kubespray](https://kubernetes.io/docs/setup/production-environment/tools/kubespray/)  
   в. Задеплоить Kubernetes на подготовленные ранее инстансы, в случае нехватки каких-либо ресурсов вы всегда можете создать их при помощи Terraform.
2. Альтернативный вариант: воспользуйтесь сервисом [Yandex Managed Service for Kubernetes](https://cloud.yandex.ru/services/managed-kubernetes)  
  а. С помощью terraform resource для [kubernetes](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster) создать **региональный** мастер kubernetes с размещением нод в разных 3 подсетях      
  б. С помощью terraform resource для [kubernetes node group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group)
  
Ожидаемый результат:

1. Работоспособный Kubernetes кластер.
2. В файле `~/.kube/config` находятся данные для доступа к кластеру.
3. Команда `kubectl get pods --all-namespaces` отрабатывает без ошибок.


**Создадим инфраструктуру под Kubernetes-кластер**

[**terraform**](terraform/)

[ig.tf](terraform/ig.tf)
[nlb.tf](terraform/nlb.tf)
[main.tf](terraform/main.tf)
[prov.tf](terraform/prov.tf)
[var.tf](terraform/var.tf)
[vpc.tf](terraform/vpc.tf)
[cluster.tf](terraform/cluster.tf)
[locals.tf](terraform/locals.tf)
[rs.tf](terraform/rs.tf)
[output.tf](terraform/output.tf)
[cc.yml](terraform/cc.yml)
[hosts.tftpl](terraform/hosts.tftpl)

<details>
    <summary>terraform plan</summary>

```terraform
root@devnet:/home/bosone/devops-diplom-yandexcloud/terraform# terraform plan
data.template_file.cloudinit: Reading...
data.template_file.cloudinit: Read complete after 0s [id=48ea1a58580d2fc98a086c492fa5bd9c501dca4ae4ad9d8e6593353bb21bfb4e]
data.yandex_compute_image.ubuntu: Reading...
data.local_file.id_key: Reading...
data.local_file.id_key: Read complete after 0s [id=e4cf5ba355e1fcc0a7fb29c03e88e9ae979b0aad]
data.yandex_compute_image.ubuntu: Read complete after 1s [id=fd84rmelvcpjp2jpo1gq]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  + create

Terraform will perform the following actions:

  # local_file.hosts will be created
  + resource "local_file" "hosts" {
      + content              = (known after apply)
      + content_base64sha256 = (known after apply)
      + content_base64sha512 = (known after apply)
      + content_md5          = (known after apply)
      + content_sha1         = (known after apply)
      + content_sha256       = (known after apply)
      + content_sha512       = (known after apply)
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "../kubespray/inventory/mycluster/hosts.ini"
      + id                   = (known after apply)
    }

  # null_resource.app_apply will be created
  + resource "null_resource" "app_apply" {
      + id = (known after apply)
    }

  # null_resource.kubespray_cp will be created
  + resource "null_resource" "kubespray_cp" {
      + id = (known after apply)
    }

  # null_resource.kubespray_init will be created
  + resource "null_resource" "kubespray_init" {
      + id = (known after apply)
    }

  # null_resource.mon_init will be created
  + resource "null_resource" "mon_init" {
      + id = (known after apply)
    }

  # time_sleep.wait_30s will be created
  + resource "time_sleep" "wait_30s" {
      + create_duration = "30s"
      + id              = (known after apply)
    }

  # yandex_compute_instance_group.ig-vm["0"] will be created
  + resource "yandex_compute_instance_group" "ig-vm" {
      + created_at          = (known after apply)
      + deletion_protection = false
      + folder_id           = "b1g6mhank6ep202dhg0g"
      + id                  = (known after apply)
      + instances           = (known after apply)
      + name                = "master"
      + service_account_id  = "ajearkca94v5dgv6jlvs"
      + status              = (known after apply)

      + allocation_policy {
          + zones = [
              + "ru-central1-a",
              + "ru-central1-b",
              + "ru-central1-d",
            ]
        }

      + deploy_policy {
          + max_creating     = 3
          + max_deleting     = 3
          + max_expansion    = 3
          + max_unavailable  = 3
          + startup_duration = 0
          + strategy         = (known after apply)
        }

      + instance_template {
          + labels      = (known after apply)
          + metadata    = {
              + "serial-port-enable" = "1"
              + "user-data"          = <<-EOT
                    #cloud-config
                    
                    users:
                      - name: root
                        groups: sudo
                        shell: /bin/bash
                        sudo: ['ALL=(ALL) NOPASSWD:ALL']
                        ssh_authorized_keys:
                          - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILdkOvbTSi6UF9rSTJ+tkvPH02xLZJInKUwjxMyH6OAR bos.one@mail.ru
                EOT
            }
          + name        = "master-{instance.index}"
          + platform_id = "standard-v2"

          + boot_disk {
              + device_name = (known after apply)
              + mode        = "READ_WRITE"

              + initialize_params {
                  + image_id    = "fd84rmelvcpjp2jpo1gq"
                  + size        = 20
                  + snapshot_id = (known after apply)
                  + type        = "network-ssd"
                }
            }

          + network_interface {
              + ip_address   = (known after apply)
              + ipv4         = true
              + ipv6         = (known after apply)
              + ipv6_address = (known after apply)
              + nat          = true
              + network_id   = (known after apply)
              + subnet_ids   = (known after apply)
            }

          + network_settings {
              + type = "STANDARD"
            }

          + resources {
              + core_fraction = 5
              + cores         = 2
              + memory        = 4
            }

          + scheduling_policy {
              + preemptible = true
            }
        }

      + scale_policy {
          + fixed_scale {
              + size = 3
            }
        }
    }

  # yandex_compute_instance_group.ig-vm["1"] will be created
  + resource "yandex_compute_instance_group" "ig-vm" {
      + created_at          = (known after apply)
      + deletion_protection = false
      + folder_id           = "b1g6mhank6ep202dhg0g"
      + id                  = (known after apply)
      + instances           = (known after apply)
      + name                = "worker"
      + service_account_id  = "ajearkca94v5dgv6jlvs"
      + status              = (known after apply)

      + allocation_policy {
          + zones = [
              + "ru-central1-a",
              + "ru-central1-b",
              + "ru-central1-d",
            ]
        }

      + deploy_policy {
          + max_creating     = 2
          + max_deleting     = 2
          + max_expansion    = 2
          + max_unavailable  = 2
          + startup_duration = 0
          + strategy         = (known after apply)
        }

      + instance_template {
          + labels      = (known after apply)
          + metadata    = {
              + "serial-port-enable" = "1"
              + "user-data"          = <<-EOT
                    #cloud-config
                    
                    users:
                      - name: root
                        groups: sudo
                        shell: /bin/bash
                        sudo: ['ALL=(ALL) NOPASSWD:ALL']
                        ssh_authorized_keys:
                          - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILdkOvbTSi6UF9rSTJ+tkvPH02xLZJInKUwjxMyH6OAR bos.one@mail.ru
                EOT
            }
          + name        = "worker-{instance.index}"
          + platform_id = "standard-v2"

          + boot_disk {
              + device_name = (known after apply)
              + mode        = "READ_WRITE"

              + initialize_params {
                  + image_id    = "fd84rmelvcpjp2jpo1gq"
                  + size        = 20
                  + snapshot_id = (known after apply)
                  + type        = "network-hdd"
                }
            }

          + network_interface {
              + ip_address   = (known after apply)
              + ipv4         = true
              + ipv6         = (known after apply)
              + ipv6_address = (known after apply)
              + nat          = true
              + network_id   = (known after apply)
              + subnet_ids   = (known after apply)
            }

          + network_settings {
              + type = "STANDARD"
            }

          + resources {
              + core_fraction = 5
              + cores         = 2
              + memory        = 2
            }

          + scheduling_policy {
              + preemptible = true
            }
        }

      + scale_policy {
          + fixed_scale {
              + size = 2
            }
        }
    }

  # yandex_compute_instance_group.ig-vm["2"] will be created
  + resource "yandex_compute_instance_group" "ig-vm" {
      + created_at          = (known after apply)
      + deletion_protection = false
      + folder_id           = "b1g6mhank6ep202dhg0g"
      + id                  = (known after apply)
      + instances           = (known after apply)
      + name                = "ingress"
      + service_account_id  = "ajearkca94v5dgv6jlvs"
      + status              = (known after apply)

      + allocation_policy {
          + zones = [
              + "ru-central1-a",
              + "ru-central1-b",
              + "ru-central1-d",
            ]
        }

      + deploy_policy {
          + max_creating     = 2
          + max_deleting     = 2
          + max_expansion    = 2
          + max_unavailable  = 2
          + startup_duration = 0
          + strategy         = (known after apply)
        }

      + instance_template {
          + labels      = (known after apply)
          + metadata    = {
              + "serial-port-enable" = "1"
              + "user-data"          = <<-EOT
                    #cloud-config
                    
                    users:
                      - name: root
                        groups: sudo
                        shell: /bin/bash
                        sudo: ['ALL=(ALL) NOPASSWD:ALL']
                        ssh_authorized_keys:
                          - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILdkOvbTSi6UF9rSTJ+tkvPH02xLZJInKUwjxMyH6OAR bos.one@mail.ru
                EOT
            }
          + name        = "ingress-{instance.index}"
          + platform_id = "standard-v2"

          + boot_disk {
              + device_name = (known after apply)
              + mode        = "READ_WRITE"

              + initialize_params {
                  + image_id    = "fd84rmelvcpjp2jpo1gq"
                  + size        = 20
                  + snapshot_id = (known after apply)
                  + type        = "network-hdd"
                }
            }

          + network_interface {
              + ip_address   = (known after apply)
              + ipv4         = true
              + ipv6         = (known after apply)
              + ipv6_address = (known after apply)
              + nat          = true
              + network_id   = (known after apply)
              + subnet_ids   = (known after apply)
            }

          + network_settings {
              + type = "STANDARD"
            }

          + resources {
              + core_fraction = 5
              + cores         = 2
              + memory        = 2
            }

          + scheduling_policy {
              + preemptible = true
            }
        }

      + scale_policy {
          + fixed_scale {
              + size = 2
            }
        }
    }

  # yandex_dns_recordset.rs["0"] will be created
  + resource "yandex_dns_recordset" "rs" {
      + data    = (known after apply)
      + id      = (known after apply)
      + name    = "app.bosone.ru."
      + ttl     = 200
      + type    = "A"
      + zone_id = "dns7l9gn3jfmq8psoskj"
    }

  # yandex_lb_network_load_balancer.nlb["0"] will be created
  + resource "yandex_lb_network_load_balancer" "nlb" {
      + created_at          = (known after apply)
      + deletion_protection = (known after apply)
      + folder_id           = (known after apply)
      + id                  = (known after apply)
      + name                = "nlb-app"
      + region_id           = (known after apply)
      + type                = "external"

      + attached_target_group {
          + target_group_id = (known after apply)

          + healthcheck {
              + healthy_threshold   = 2
              + interval            = 2
              + name                = "tcp"
              + timeout             = 1
              + unhealthy_threshold = 2

              + tcp_options {
                  + port = 30001
                }
            }
        }

      + listener {
          + name        = "listener-app"
          + port        = 80
          + protocol    = (known after apply)
          + target_port = 30001

          + external_address_spec {
              + address    = (known after apply)
              + ip_version = "ipv4"
            }
        }
      + listener {
          + name        = "listener-grafana"
          + port        = 3000
          + protocol    = (known after apply)
          + target_port = 30000

          + external_address_spec {
              + address    = (known after apply)
              + ip_version = "ipv4"
            }
        }
    }

  # yandex_lb_target_group.lbg-ingress will be created
  + resource "yandex_lb_target_group" "lbg-ingress" {
      + created_at = (known after apply)
      + folder_id  = (known after apply)
      + id         = (known after apply)
      + name       = "lbg-ingress"
      + region_id  = (known after apply)
    }

  # yandex_vpc_network.network will be created
  + resource "yandex_vpc_network" "network" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "network"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.public["sub-a"] will be created
  + resource "yandex_vpc_subnet" "public" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "public-a"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.0.1.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

  # yandex_vpc_subnet.public["sub-b"] will be created
  + resource "yandex_vpc_subnet" "public" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "public-b"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.0.2.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-b"
    }

  # yandex_vpc_subnet.public["sub-d"] will be created
  + resource "yandex_vpc_subnet" "public" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "public-d"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.0.3.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-d"
    }

Plan: 16 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + instance_group_masters_public_ips = (known after apply)
  + load_balancer_public_ip           = (known after apply)

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run
"terraform apply" now.
```
</details>

Применение конфигурации
<p align="center">
    <img width="1200 height="600" src="/img/ter_apply.png">
</p>

**Подготовленные группы ВМ**

[ig.tf](terraform/ig.tf)

<p align="center">
    <img width="1200 height="600" src="/img/yc_web_ig.png">
</p>

<p align="center">
    <img width="1200 height="600" src="/img/yc_web_ig_vm.png">
</p>

```
В Instance group используем различные типы групп ВМ, с различным размером, ресурсами, политикой развертывания (для быстроты развертывания внтури группы установлен одинаковый параметр), интерйесы ВМ размещены в разных подсетях для отказоустойчивости, всем машинам назначается публичный адрес.
```

**Балансировщик нагрузки**

[nlb.tf](terraform/nlb.tf)

<p align="center">
    <img width="1200 height="600" src="/img/yc_web_nlb.png">
</p>

```
Балансировщик нацелен на определённую группу ВМ, на которую будет приходить трафик, и прослушивает порты, на которых будет находиться наше приложение и интерфейс мониторинга.
```

**Kubernetes-кластер**

Для конфигурирования кластера клонируем проект Kubespray -<br> 
git clone https://github.com/kubernetes-sigs/kubespray.git<br>
устанавливаем зависимости Kubespray -<br>
pip3 install -r kubespray/requirements.txt --break-system-packages<br>

Скопируем каталог sample с файлами-шаблонами настройки кластера в [kubespray inventory](kubespray_inventory/), изменим параметры в шаблонах для своего кластера.
При разворачивании конфигурации будем копировать подготовленный [kubespray inventory](kubespray_inventory/) в склонированный репозиторий Kubespray.

Также в каталог кластера с подготовленной конфигурацией будем добавлять файл - hosts.ini, который получаем в соответствии с шаблоном - [hosts.tftpl](terraform/hosts.tftpl), при создании инфраструктуры.

[cluster.tf](terraform/cluster.tf)

Деплой кластера при помощи Kubespray - [kubespray_init.sh](kubespray_init.sh):
 - Разворачиваем kubespray
 - Копируем конфиг файл для управления кластером на локалюную машину
 - Заменяем адрес кластера в конфиг файле
 - Задаём роли для нод в кластере

<p align="center">
    <img width="1200 height="600" src="/img/kube_config.png">
</p>

<p align="center">
    <img width="1200 height="600" src="/img/kubectl_get_nodes.png">
</p>

<p align="center">
    <img width="1200 height="600" src="/img/kubectl_get_pods_all.png">
</p>

---
### Создание тестового приложения

Для перехода к следующему этапу необходимо подготовить тестовое приложение, эмулирующее основное приложение разрабатываемое вашей компанией.

Способ подготовки:

1. Рекомендуемый вариант:  
   а. Создайте отдельный git репозиторий с простым nginx конфигом, который будет отдавать статические данные.  
   б. Подготовьте Dockerfile для создания образа приложения.  
2. Альтернативный вариант:  
   а. Используйте любой другой код, главное, чтобы был самостоятельно создан Dockerfile.

Ожидаемый результат:

1. Git репозиторий с тестовым приложением и Dockerfile.
2. Регистри с собранным docker image. В качестве регистри может быть DockerHub или [Yandex Container Registry](https://cloud.yandex.ru/services/container-registry), созданный также с помощью terraform.


**Git репозиторий -**
[https://github.com/bosone87/test-app.git](https://github.com/bosone87/test-app.git)<br>
**Регистри DockerHub -**
[https://hub.docker.com/r/bosone/test-app](https://hub.docker.com/r/bosone/test-app)

---
### Подготовка cистемы мониторинга и деплой приложения

Уже должны быть готовы конфигурации для автоматического создания облачной инфраструктуры и поднятия Kubernetes кластера.  
Теперь необходимо подготовить конфигурационные файлы для настройки нашего Kubernetes кластера.

Цель:
1. Задеплоить в кластер [prometheus](https://prometheus.io/), [grafana](https://grafana.com/), [alertmanager](https://github.com/prometheus/alertmanager), [экспортер](https://github.com/prometheus/node_exporter) основных метрик Kubernetes.
2. Задеплоить тестовое приложение, например, [nginx](https://www.nginx.com/) сервер отдающий статическую страницу.

Способ выполнения:
1. Воспользовать пакетом [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus), который уже включает в себя [Kubernetes оператор](https://operatorhub.io/) для [grafana](https://grafana.com/), [prometheus](https://prometheus.io/), [alertmanager](https://github.com/prometheus/alertmanager) и [node_exporter](https://github.com/prometheus/node_exporter). При желании можете собрать все эти приложения отдельно.
2. Для организации конфигурации использовать [qbec](https://qbec.io/), основанный на [jsonnet](https://jsonnet.org/). Обратите внимание на имеющиеся функции для интеграции helm конфигов и [helm charts](https://helm.sh/)
3. Если на первом этапе вы не воспользовались [Terraform Cloud](https://app.terraform.io/), то задеплойте и настройте в кластере [atlantis](https://www.runatlantis.io/) для отслеживания изменений инфраструктуры. Альтернативный вариант 3 задания: вместо Terraform Cloud или atlantis настройте на автоматический запуск и применение конфигурации terraform из вашего git-репозитория в выбранной вами CI-CD системе при любом комите в main ветку. Предоставьте скриншоты работы пайплайна из CI/CD системы.

Ожидаемый результат:
1. Git репозиторий с конфигурационными файлами для настройки Kubernetes.
2. Http доступ к web интерфейсу grafana.
3. Дашборды в grafana отображающие состояние Kubernetes кластера.
4. Http доступ к тестовому приложению.

**Git репозиторий**<br>

[https://github.com/bosone87/diplom-parctise.git](https://github.com/bosone87/diplom-parctise.git)

**Мониоринг**

Используем готовый пакет мониторинга кластера - [Prometheus Community Kubernetes Helm Charts](https://prometheus-community.github.io/helm-charts)<br>
Для grafana подготовим сервис NodePort и настройки хранилища -<br>
[grafana-svc.yml](monitoring/grafana-svc.yml)
[garafana.yml](monitoring/grafana.yml)

Установим - [mon_install.sh](monitoring/mon_install.sh)

<p align="center">
    <img width="1200 height="600" src="/img/web_grafana.png">
</p>

<p align="center">
    <img width="1200 height="600" src="/img/web_grafana1.png">
</p>

<p align="center">
    <img width="1200 height="600" src="/img/web_grafana2.png">
</p>

<p align="center">
    <img width="1200 height="600" src="/img/web_grafana3.png">
</p>

<p align="center">
    <img width="1200 height="600" src="/img/web_grafana4.png">
</p>

[Grafana](http://app.bosone:3000)
admin/prom-operator

**Тестовое приложение**
Подготовим Helm Chart тестового приложения - [Test-app](cicd/netology-app/deploy/)<br>
Установим в кластер.

<p align="center">
    <img width="1200 height="600" src="/img/app_helm_deploy.png">
</p>

<p align="center">
    <img width="1200 height="600" src="/img/app_web.png">
</p>

[Test-app](http://app.bosone.ru)

---
### Установка и настройка CI/CD

Осталось настроить ci/cd систему для автоматической сборки docker image и деплоя приложения при изменении кода.

Цель:

1. Автоматическая сборка docker образа при коммите в репозиторий с тестовым приложением.
2. Автоматический деплой нового docker образа.

Можно использовать [teamcity](https://www.jetbrains.com/ru-ru/teamcity/), [jenkins](https://www.jenkins.io/), [GitLab CI](https://about.gitlab.com/stages-devops-lifecycle/continuous-integration/) или GitHub Actions.

Ожидаемый результат:

1. Интерфейс ci/cd сервиса доступен по http.
2. При любом коммите в репозиторие с тестовым приложением происходит сборка и отправка в регистр Docker образа.
3. При создании тега (например, v1.0.0) происходит сборка и отправка с соответствующим label в регистри, а также деплой соответствующего Docker образа в кластер Kubernetes.

**CI/CD**

Настроим pipeline в Gitlab.
Установим Gitlab-agent в кластер:

[helm_gl_agent.sh](cicd/helm_gl_agent.sh)

<p align="center">
    <img width="1200 height="600" src="/img/gitlab_agent_inst.png">
</p>

<p align="center">
    <img width="1200 height="600" src="/img/gitlab_agent_web.png">
</p>

Настроим конфиг агента для доступа к репозиторию, настроим стадии пайплайна и загрузим Helm Chart приложения для сборки.

[https://gitlab.com/bos.one/netology-app](https://gitlab.com/bos.one/netology-app)

Локально внесем изменения в конфигурацию приложения и отправим в репозиторий с новым коммитом и новым тэгом:
<p align="center">
    <img width="1200 height="600" src="/img/gilab_app_commit_tag.png">
</p>

Пайплайн:
<p align="center">
    <img width="1200 height="600" src="/img/gitlab_pipeline.png">
</p>

Стадия сборки приложения - [build stage](https://gitlab.com/bos.one/netology-app/-/jobs/7053435606)<br>
Стадия деплоя - [deploy stage](https://gitlab.com/bos.one/netology-app/-/jobs/7053445299)

Новая версия приложения в кластере
<p align="center">
    <img width="1200 height="600" src="/img/app_new_tag.png">
</p>

Новая версиия веб приложения - [http://app.bosone.ru](http://app.bosone.ru)
<p align="center">
    <img width="1200 height="600" src="/img/app_new_web.png">
</p>

---
## Что необходимо для сдачи задания?

1. Репозиторий с конфигурационными файлами Terraform и готовность продемонстрировать создание всех ресурсов с нуля.
2. Пример pull request с комментариями созданными atlantis'ом или снимки экрана из Terraform Cloud или вашего CI-CD-terraform pipeline.
3. Репозиторий с конфигурацией ansible, если был выбран способ создания Kubernetes кластера при помощи ansible.
4. Репозиторий с Dockerfile тестового приложения и ссылка на собранный docker image.
5. Репозиторий с конфигурацией Kubernetes кластера.
6. Ссылка на тестовое приложение и веб интерфейс Grafana с данными доступа.
7. Все репозитории рекомендуется хранить на одном ресурсе (github, gitlab)

