#!/bin/bash

bosh -e micro-bosh -d webide-broker-service deploy paasta_web_ide_sevcie_broker.yml \
   -v stemcell_os="ubuntu-trusty"\
   -v stemcell_version="3445.2"\
   -v stemcell_alias="default"\
   -v internal_networks_name="service_private"\
   -v external_networks_name="portal_service_public"\
   -v mariadb_disk_type="10GB"\
   -v mariadb_port="3306"\
   -v mariadb_user_password="Paasta@2018"\
   -v server_port="8080"\
   -v webide_servers=["http://115.68.47.184:8080/dashboard","http://115.68.47.185:8080/dashboard"]\
   -v serviceDefinition_id="af86588c-6212-11e7-907b-b6006ad3webide0"\
   -v serviceDefinition_plan1_id="a5930564-6212-11e7-907b-b6006ad3webide1"\
