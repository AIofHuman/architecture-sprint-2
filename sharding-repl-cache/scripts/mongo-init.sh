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
docker exec -i shard1_primary mongosh --host shard1_primary --port 27018 <<EOF
rs.initiate(
  {
    _id: 'shard1rs',
    members: [
      { _id: 0, host: 'shard1_primary:27018' },
      { _id: 1, host: 'shard1_secondary1:27018' },
      { _id: 2, host: 'shard1_secondary2:27018' }
    ]
  }
);
print("shard1 was initiated")
exit();
EOF
#
docker exec -i shard2_primary mongosh --host shard2_primary --port 27019 <<EOF
rs.initiate(
  {
    _id: 'shard2rs',
    members: [
      { _id: 0, host: 'shard2_primary:27019' },
      { _id: 1, host: 'shard2_secondary1:27019' },
      { _id: 2, host: 'shard2_secondary2:27019' }
    ]
  }
);
print("shard2 was initiated")
exit();
EOF
# # #
docker exec -i mongos_router mongosh --host mongos_router --port 27020 <<EOF
sh.addShard( "shard1rs/shard1_primary:27018");
sh.addShard( "shard2rs/shard2_primary:27019");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } );
use somedb
for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})
db.helloDoc.countDocuments()
print("mongos_router test pass") 
exit();
EOF
