docker exec -i shard1_primary mongosh --host shard1_primary --port 27018 <<EOF
use somedb
print("shard1 documents number=");
db.helloDoc.countDocuments();
exit();
EOF 
