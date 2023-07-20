https://repost.aws/knowledge-center/copy-s3-objects-account

aws s3 cp --recursive s3://<SOURCE BUCKET>/ s3://<DESTINATION BUCKET> --acl bucket-owner-full-control
