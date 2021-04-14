DB_HOST=$1

read -s -p "Enter DB Password: " DBPASS; echo
read -s -p "Enter desired user Password: " USERPASS; echo

# create db and user
echo "CREATE DATABASE ctfd; USE ctfd; CREATE USER IF NOT EXISTS 'ctfd'@'%' IDENTIFIED BY '${USERPASS}';  GRANT ALL PRIVILEGES ON ctfd.* TO 'ctfd'@'%'; FLUSH PRIVILEGES;" | mysql -h $DB_HOST -u user "-p${DBPASS}"
