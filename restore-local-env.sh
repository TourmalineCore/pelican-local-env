#! bin/bash
# Terminate all active connections to database
kubectl exec postgresql-0 -n local -- env PGPASSWORD=admin psql -U postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'pelican_db';"

# Delete database
kubectl exec postgresql-0 -n local -- env PGPASSWORD=admin psql -U postgres -c "drop database pelican_db;"

# Create new database
kubectl exec postgresql-0 -n local -- env PGPASSWORD=admin psql -U postgres -c "create database pelican_db;"

# Copy database backup file to postgresql pod
kubectl cp pelican-local-env-db-2025-09-01T06-06-03.backup -n local postgresql-0:tmp/pelican.backup 

# Restore database from backup file
kubectl exec postgresql-0 -n local -- env PGPASSWORD=admin psql -U postgres -d pelican_db -f tmp/pelican.backup

# Unzip S3 backup archive 
unzip pelican-local-env-s3-2025-07-17T11-21-03.backup.zip -d s3-backup

# Get name of running minio-s3 pod 
MINIO_NAME=$(kubectl get pods -l app.kubernetes.io/name=minio -n local -o jsonpath='{.items[0].metadata.name}')

# Copy folder with s3 media to minio-s3 pod
kubectl cp s3-backup -n local $MINIO_NAME:/tmp/s3-backup

# Cleanup 
rm -r s3-backup

# Copy all media to minio-s3 bucket
kubectl exec $MINIO_NAME -n local -- mc cp /tmp/s3-backup/ local/pelican-local-env/ --recursive

# Cleanup
kubectl exec $MINIO_NAME -n local -- rm -r /tmp/s3-backup
