# cf2Graph
Simple script that parses Cloudfoundry Metadata to be feed into graphviz.
The script considers the following elements
 *  Orgs
 * Spaces
 * Apps
 * Routes
 * Service Instances
 * Service Bindungs
 * Route Bindings
 * Container Networks

# Usage
```
  cf login
  ./create.sh | dot -Tjpg -o out.jpg
```
