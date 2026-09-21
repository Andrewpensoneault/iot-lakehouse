#!/bin/sh
set -eu

: "${S3_ACCESS_KEY:?S3_ACCESS_KEY is required}"
: "${S3_SECRET_KEY:?S3_SECRET_KEY is required}"

mkdir -p /etc/seaweedfs
umask 077

jq -n \
  '{
    identities: [
      {
        name: "lakehouse",
        credentials: [
          {
            accessKey: env.S3_ACCESS_KEY,
            secretKey: env.S3_SECRET_KEY,
          }
        ],
        actions: ["Admin", "Read", "Write", "List", "Tagging"]
      }
    ]
  }' > /etc/seaweedfs/s3.json

exec weed server \
  -dir=/data \
  -s3 \
  -s3.config=/etc/seaweedfs/s3.json \
  -ip.bind=0.0.0.0 
