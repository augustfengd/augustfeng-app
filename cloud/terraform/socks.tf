module "socks" {
  source = "./socks"
  aws_key_pair_name = aws_key_pair.augustfeng.key_name
  aws_vpc_ids = {
    compute = aws_vpc.compute.id
  }
  aws_subnet_ids = {
    a = aws_subnet.compute-1a.id
    b = aws_subnet.compute-1b.id
    c = aws_subnet.compute-1c.id
    d = aws_subnet.compute-1d.id
    e = aws_subnet.compute-1e.id
    f = aws_subnet.compute-1f.id
  }
  providers = {
    aws = aws.ca-central-1
  }
}
