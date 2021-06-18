#please use . set_fortos_env.sh to execute it. make sure you put a space between . and set_foros_env.sh under your shell
ipaddress=`terraform output  -json  PrimaryFortigateEIP | jq -r .ip_address`
export FORTIOS_ACCESS_HOSTNAME=$ipaddress
echo $ipaddress
token=`./firewall_remote_ls_main -addr $FORTIOS_ACCESS_HOSTNAME`
tokenstring=`echo $token | cut -d ' ' -f6`
echo $tokenstring
export FORTIOS_ACCESS_TOKEN=$tokenstring

export $FORTIOS_INSECURE=true

echo $FORTIOS_ACCESS_HOSTNAME
echo $FORTIOS_ACCESS_TOKEN

