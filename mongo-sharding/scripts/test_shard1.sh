docker exec -i shard1 mongosh --host shard1 --port 27018 <<EOF
use somedb
print("shard1 documents number=");
db.helloDoc.countDocuments();
exit();
EOF 
