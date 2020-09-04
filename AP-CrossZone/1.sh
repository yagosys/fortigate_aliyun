terraform apply -var "access_key=$access_key_id" --var "secret_key=$access_key_secret"  -var 'region=cn-hangzhou' -var  'fgt1_availability_zone=cn-hangzhou-i' -var 'fgt2_availability_zone=cn-hangzhou-h' -var 'instance_ami=m-bp11ljawfkjgf7ruac4y' -var 'instance=ecs.hfc6.2xlarge'

