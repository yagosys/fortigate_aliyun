#aliyun ecs DescribeImages --ImageOwnerAlias=marketplace --RegionId=cn-shanghai --PageNumber=5 --PageSize=100  | jq .Images.Image[].ImageName
#for i in {1..20};do aliyun ecs DescribeImages --ImageOwnerAlias=marketplace --RegionId=cn-shanghai --PageNumber=$i --PageSize=100  | jq '.Images.Image[] | .ImageName +" " +.ImageId' | grep Fortinet;done
region='cn-zhangjiakou'
for i in {1..20};do aliyun ecs DescribeImages --ImageOwnerAlias=marketplace --RegionId=$region --PageNumber=$i --PageSize=100  | jq '.Images.Image[] | .ImageName +" " +.ImageId + " "+.ProductCode' | grep Fortinet;done
