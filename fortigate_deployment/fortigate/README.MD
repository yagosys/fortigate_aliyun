# preparation 

```
aliyun configure --profile default
```

# modify intl.auto.tfvars according

#
```
terraform init
terraform apply
```
# reboot via VNC console


after deploy, you MUST go to alibaba cloud console , use vnc console to connect into both fortigate and do 

```
execute factuoryreset keepvmlicense
```

