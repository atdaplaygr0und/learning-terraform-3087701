resource "aws_instance" "web" {
  ami           = data.aws_ami.app_ami.id
  instance_type = "t3.nano"
  instance_type = var.instance_type

  tags = {
    Name = "HelloWorld"
  }
}
