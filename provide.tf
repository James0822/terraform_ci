terraform {
  backend "s3" {
    # S3 桶名（替换为你的桶名）
    bucket         = "james-tf-state-bucket-ap-southeast-1"
    # 桶所在的 AWS 区域（与桶实际区域一致，如新加坡）
    region         = "ap-southeast-1"
  }
}
