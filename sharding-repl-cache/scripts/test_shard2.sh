docker exec -i shard2_primary mongosh --host shard2_primary --port 27019 <<EOF
use somedb
print("shard2 documents number=");
db.helloDoc.countDocuments();
exit(); 
EOF