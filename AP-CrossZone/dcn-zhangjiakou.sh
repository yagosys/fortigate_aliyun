
instanceType='ecs.hfc6.2xlarge'
region='cn-zhangjiakou'
instance_ami='m-8vb4uwcxp5otfnqtsl5k'
echo instance_ami=$instance_ami
echo reading availability zone for instanceType $instanceType in region $region

read -r -d "\n" zonea zoneb  zonec <<<$(aliyun ecs DescribeAvailableResource --DestinationResource InstanceType --IoOptimized --InstanceType $instanceType  --region $region  | jq -r  '.AvailableZones.AvailableZone[] | "\(.ZoneId)"')

echo availability_zone1=$zonea
echo availability_zone2=$zoneb
echo availability_zone3=$zonec
echo 'generate terraform plan...'
terraform destroy \
	-var "access_key=$access_key_id" \
	-var "secret_key=$access_key_secret" \
	-var "region=$region" \
	-var "fgt1_availability_zone=$zonea" \
	-var "fgt2_availability_zone=$zoneb" \
	-var "instance_ami=$instance_ami" \
	-var "instance=$instanceType"
