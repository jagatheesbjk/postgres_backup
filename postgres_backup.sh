#!/bin/bash
# Add the backup dir location, Postgres, and postgresdump location
DATE=$(date +%d-%m-%Y)
BACKUP_DIR="/backup/postgres/backup/daily"
PSQL_HOST="103.133.215.248"
PORT="5432"
PSQL_USER="postgres"
PSQL="$(which psql)"

# To create a new directory in the backup directory location based on the date
mkdir -p $BACKUP_DIR/$DATE

# To get a list of databases
databases=$($PSQL -h $PSQL_HOST -p $PORT -U $PSQL_USER -c '\l' | awk '{ print $1 }' | awk 'NR==4,NR==10{print $1}'| sed 's/|//g' | tr -d "/n" | grep -Ev "temp")

# To dump each database in a separate file
for db in $databases; do
echo $db
backup=$(/bin/pg_dump -U $PSQL_USER -h PSQL_HOST -p $PORT -d $db > "$BACKUP_DIR/$DATE/$db")
done

echo -e "====Backup As on Date: $DATE==="
echo "$backup"
echo -e "==============================="

# Delete the files older than 7 days
find $BACKUP_DIR/* -type d -mtime +7 -exec rm -rf {} \;