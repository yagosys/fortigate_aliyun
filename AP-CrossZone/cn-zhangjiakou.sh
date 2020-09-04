terraform apply -var "access_key=$access_key_id" --var "secret_key=$access_key_secret"  -var 'region=cn-zhangjiakou' -var  'fgt1_availability_zone=cn-zhangjiakou-a' -var 'fgt2_availability_zone=cn-zhangjiakou-b' -var 'instance_ami=m-8vb4uwcxp5otfnqtsl5k' -var 'instance=ecs.hfc6.2xlarge'

