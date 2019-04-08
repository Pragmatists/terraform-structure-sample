{
    "Id": "${s3_bucket}-policy",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "bucket_policy_site_main",
            "Action": [
                "s3:GetObject"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:s3:::${s3_bucket}/*",
            "Principal": "*"
        }
    ]
}
