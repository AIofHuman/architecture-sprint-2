docker exec -i shard2 mongosh --host shard2 --port 27019 <<EOF
use somedb
print("shard2 documents number=");
db.helloDoc.countDocuments();
exit(); 
EOF