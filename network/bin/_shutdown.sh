#PEER_MODE=net
#Command=dev-init.sh -s 
#Generated: Wed Apr 27 03:37:32 UTC 2022 
docker-compose  -f ./compose/docker-compose.base.yaml     -f ./compose/docker-compose.couchdb.yaml     down 
