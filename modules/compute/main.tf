resource "aws_instance" "wp-servers" {
  ami                    = var.ami
  instance_type          = lookup(var.instance_type, terraform.workspace, "t2.micro")
  key_name               = "key-wp"
  vpc_security_group_ids = [var.wp-server-sg]
  count                  = 2
  subnet_id              = var.private_subnet_ids[count.index + 1]
  depends_on             = [aws_instance.jumpbox]
  connection {
    type         = "ssh"
    user         = "ubuntu"
    private_key  = file("/home/sakib/.ssh/key.pem")
    host         = self.private_ip                # as in private subnet we are using the private ip
    bastion_host = aws_instance.jumpbox.public_ip # Use the jumpbox as a bastion host
  }
  provisioner "file" {
    source      = "./installation.sh"
    destination = "/home/ubuntu/installation.sh"
  }
  provisioner "remote-exec" {
    inline = [
      # Install Nginx
      "sudo apt update -y",
      "sudo apt install nginx -y",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx",
      # Install PHP
      "sudo apt install php-fpm php-mysql php-curl php-dom php-json php-mbstring php-xml php-zip -y",
      "php -v",
      # Download and Configure WordPress
      "cd /tmp",
      "wget https://wordpress.org/latest.tar.gz",
      "tar -xvzf latest.tar.gz",
      "sudo mv wordpress /var/www/",
      "sudo chown -R www-data:www-data /var/www/wordpress",
      "sudo chmod -R 755 /var/www/wordpress",
    ]
  }
  tags = {
    Name = "wp-server-${count.index + 1}"
  }
}

resource "aws_instance" "jumpbox" {
  ami                    = var.ami
  instance_type          = lookup(var.instance_type, terraform.workspace, "t2.micro")
  vpc_security_group_ids = [var.jumpbox-sg]
  key_name               = "key-wp"
  subnet_id              = var.public_subnet_id
  tags = {
    Name = "jumpbox"
  }
}

resource "aws_key_pair" "key-wp" {
  key_name   = "key-wp"
  public_key = file(var.public_key_path)
}