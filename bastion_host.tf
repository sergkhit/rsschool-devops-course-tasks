resource "aws_instance" "rs-task-bastion_host" {
  ami                         = var.ec2_ubuntu_ami
  instance_type               = var.aws_instance_pub
  subnet_id                   = aws_subnet.TFpublic-a.id
  security_groups             = [aws_security_group.rs-task-bastion.id]
  key_name                    = aws_key_pair.rs-task-tf-ssh-key.key_name
  associate_public_ip_address = true

  tags = {
    Terraform = "true"
    Project   = var.project
    Owner     = var.user_owner
    Name      = "rs-task-bastion-host"
  }
}

resource "null_resource" "install_nginx" {
  depends_on = [aws_instance.rs-task-bastion_host]

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]
  }
      connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("rs-task-key.pem")
      host        = aws_instance.rs-task-bastion_host.public_ip
    }
}

resource "null_resource" "configure_nginx" {
  depends_on = [null_resource.install_nginx]

  provisioner "file" {
    source      = "jenkins.conf"  
    destination = "/etc/nginx/sites-available/jenkins.conf"
    
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("rs-task-key.pem")
      host        = aws_instance.rs-task-bastion_host.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo ln -s /etc/nginx/sites-available/jenkins.conf /etc/nginx/sites-enabled/",
      "sudo nginx -t",
      "sudo systemctl restart nginx"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("rs-task-key.pem")
      host        = aws_instance.rs-task-bastion_host.public_ip
    }
  }
}

