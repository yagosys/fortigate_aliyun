profile="default"
region="cn-hongkong"
instance_type="auto"
subnet_cidr="192.168.0.0/16"
hubvpc_vswitch_a_cidr_13="192.168.13.0/24"
hubvpc_vswitch_b_cidr_23="192.168.23.0/24"

vpc1_subnets="10.1.0.0/16"
vpc1_vswitch0_subnet="10.1.0.0/24"
vpc1_vswitch1_subnet="10.1.1.0/24"

vpc1_subnet_cidr1= "10.0.0.0/8"
vpc2_subnet_cidr2="10.0.0.0/8"

vpc2_subnets="10.0.0.0/16"
vpc2_vswitch0_subnet="10.0.0.0/24"
vpc2_vswitch1_subnet="10.0.1.0/24" 

image_id="m-j6c2if5qv9k4gewg9sen"
most_recent_image_search_string_from_marketplace="FortiGate-7.4.1.+BYOL"
number_of_fortigate=2
number_of_zone=1
custom_rt=1
mgmt_eip=1
eip=1
securehub="0"
spoke_linux_vpc_1=0
spoke_linux_vpc_2=0
cpu_core_count=8
memory_size=16
eni_amount=4

fortigate= {
          hostname=[
                    "fortigate-active",
                    "fortigate-passive",
                ]
            license_file=[
                    "~/lic/FGVMULTM23000010.lic",
                    "~/lic/FGVMULTM23000044.lic",
                ]
            internet_max_bandwidth_out=[
                    "0",
                    "0",
                ]
            ha_priority=[
                     "200",
                     "100",
                ]
}
