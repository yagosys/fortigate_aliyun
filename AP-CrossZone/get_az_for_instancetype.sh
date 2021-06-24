instanceType='ecs.hfc6.2xlarge'
region='cn-zhangjiakou'
#aliyun ecs DescribeAvailableResource --DestinationResource InstanceType --IoOptimized --InstanceType $instanceType  --region $region  | jq '.AvailableZones.AvailableZone[] | "\(.AvailableResources.AvailableResource[].SupportedResources.SupportedResource[].Value) \(.ZoneId)"'
aliyun ecs DescribeAvailableResource --DestinationResource InstanceType --IoOptimized --InstanceType $instanceType  --region $region  | jq '.AvailableZones.AvailableZone[] | "\(.ZoneId)"'
