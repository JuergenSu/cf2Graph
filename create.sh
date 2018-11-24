#!/bin/sh
 mkdir `pwd`/$1
 export CF_HOME=`pwd`/$1
 cf login -a api.run.pivotal.io -u $1 -p $2 -o a -s a
 ./create_graph.sh | dot -Tjpg -o `pwd`/$1/out.jpg
cf logout 
