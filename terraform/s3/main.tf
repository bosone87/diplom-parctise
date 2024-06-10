# SA tf

resource "yandex_iam_service_account" "sa-tf" {
    name      = "sa-tf"
}
resource "yandex_resourcemanager_folder_iam_member" "editor-tf" {
    depends_on = [yandex_iam_service_account.sa-tf]
    folder_id = var.folder_id
    role      = "editor"
    member    = "serviceAccount:${yandex_iam_service_account.sa-tf.id}"
    
}
resource "yandex_iam_service_account_static_access_key" "sa-sa-key" {
    service_account_id = yandex_iam_service_account.sa-tf.id
    description        = "access key for tf"
}

# Bucket S3

resource "yandex_storage_bucket" "tfstate-diplom" {
    depends_on = [ yandex_iam_service_account.sa-tf ]
    access_key = yandex_iam_service_account_static_access_key.sa-sa-key.access_key
    secret_key = yandex_iam_service_account_static_access_key.sa-sa-key.secret_key
    bucket = var.bucket_name
    max_size   = 10000000
    force_destroy = true
        anonymous_access_flags {
            read = false
            list = false
        }
}

# Keys files

resource "null_resource" "key" {
    depends_on = [yandex_resourcemanager_folder_iam_member.editor-tf]
    provisioner "local-exec" {
        command = "yc iam key create --folder-id b1g6mhank6ep202dhg0g --service-account-name sa-tf --output ../key.json"
        }
}
resource "null_resource" "sa_id" {
    depends_on = [ null_resource.key ]
    provisioner "local-exec" {
        command = "sed -n 3p ../key.json | awk '{print $2}' | cut -d ',' -f1 | sed 's/\"//g' > ../id.txt"
        }
}
resource "local_file" "backend-key" {
    depends_on = [yandex_iam_service_account_static_access_key.sa-sa-key]
    content    = <<EOT
        bucket     = "${yandex_storage_bucket.tfstate-diplom.bucket}"
        access_key = "${yandex_iam_service_account_static_access_key.sa-sa-key.access_key}"
        secret_key = "${yandex_iam_service_account_static_access_key.sa-sa-key.secret_key}"
        EOT
    filename   = "../secret.backend.tfvars"
}