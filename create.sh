echo "graph {"
#itterate all orgs
names=$(cf curl /v2/organizations | jq -r '.resources[] | .entity.name + ";" + .metadata.guid')
for line in $names; do
  name=`echo $line | cut -d \; -f 1`
  guid=`echo $line | cut -d \; -f 2`
  # subgraph each org
  echo "subgraph cluster_$name {"
  echo "  label=\"ORG:$name\""
    #itterate all spaces
    spaces=$(cf curl /v2/organizations/$guid/spaces | jq -r '.resources[] | .entity.name + ";" + .metadata.guid')
    for spaceline in $spaces; do
        spacename=`echo $spaceline | cut -d \; -f 1`
        spaceguid=`echo $spaceline | cut -d \; -f 2`  

        echo "subgraph cluster_$spacename {"
        echo "  label=\"Space:$spacename\""
          
          #for each space
          
          #list apps        
          cf curl /v2/spaces/$spaceguid/apps | jq -r '.resources[] | "\"" + .metadata.guid + "\"" + " [label=\"APP:" + .entity.name + "\nMem:"+(.entity.memory|tostring) + "\nSTATE: " + .entity.state  + "\"]"'     
          
          #list service instances
          cf curl /v2/spaces/$spaceguid/service_instances | jq -r '.resources[] | "\"" + .metadata.guid + "\"" + " [label=\"Service:" + .entity.name + "\"]"'

          #list routes
          cf curl /v2/spaces/$spaceguid/routes  | jq -r '.resources[] | "\"" + .metadata.guid + "\"" + " [label=\"Host:" + .entity.host + "\"]"'          
                   
        echo "}"            
    done  
    
  echo "}"
done 
 

#add router as gateway
echo "subgraph cluster_Router {"
echo " label=\"Router\""
cf curl /v2/domains  | jq -r '.resources[] | "\"" + .metadata.guid + "\"" +  " [label=\"Domain:" + .entity.name + "\"]"'
echo "}"

#add service bindings
cf curl /v2/service_bindings | jq -r '.resources[] | "\"" + .entity.app_guid + "\"" + " -- " + "\"" + .entity.service_instance_guid + "\"" '

#add route to domain Mappings
cf curl /v2/routes  | jq -r '.resources[] | "\"" + .metadata.guid + "\"" + " -- " + "\"" + .entity.domain_guid + "\""'
#add Route to app mappings
cf curl v2/route_mappings  | jq -r '.resources[] | "\"" + .entity.app_guid + "\"" + " -- " + "\"" + .entity.route_guid + "\""'

#add container Networks
cf curl /networking/v1/external/policies | jq -r '.policies[] | "\"" + .source.id + "\"" + " -- " + "\"" + .destination.id + "\"" + "[label=\"" + .destination.protocol + "/" + (.destination.ports.start|tostring) + "-" +  (.destination.ports.end|tostring)  +   "\"]"'

echo "}"


