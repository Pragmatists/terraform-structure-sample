{
  "Id": "${s3_bucket}-policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "${s3_bucket}-policy-everyone",
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${s3_bucket}/*",
      "Principal": "*"
    }
  ]
}
