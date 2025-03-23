docker exec -i configSrv mongosh --host configSrv --port 27017 <<EOF
rs.initiate(
  {
    _id : "configrs",
    members: [
      { _id : 0, host : "configSrv:27017" }
    ]
  }
);
print("configSrv was initiated")
exit(); 
EOF
#
docker exec -i shard1 mongosh --host shard1 --port 27018 <<EOF
rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1:27018" },
      ]
    }
);
print("shard1 was initiated")
exit();
EOF
#
docker exec -i shard2 mongosh --host shard2 --port 27019 <<EOF
rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 0, host : "shard2:27019" },
      ]
    }
);
print("shard2 was initiated")
exit();
EOF
# #
docker exec -i mongos_router mongosh --host mongos_router --port 27020 <<EOF
sh.addShard( "shard1/shard1:27018");
sh.addShard( "shard2/shard2:27019");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } );
use somedb
for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})
db.helloDoc.countDocuments()
print("mongos_router test pass") 
exit();
EOF
