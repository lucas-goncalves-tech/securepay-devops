resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# resource "aws_alb" "main" {
#   name = "securepay-alb"
#   load_balancer_type = "application"
#   security_groups = [aws_security_group.alb.id]
#   subnets = [aws_subnet.public.id]
# }
#
# resource "aws_alb_target_group" "api" {
#   name = "securepay-api-tg"
#   port = 8080
#   protocol = "HTTP"
#   vpc_id = aws_vpc.main.id
#
#   health_check {
#     path = "/actuator/health"
#     port = "8080"
#     protocol = "HTTP"
#     matcher = "200"
#   }
# }
#
# resource "aws_alb_listener" "http" {
#   load_balancer_arn = aws_alb.main.arn
#   port = 80
#   protocol = "HTTP"
#
#   default_action {
#     type = "forward"
#     target_group_arn = aws_alb_target_group.api.arn
#   }
# }

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public.id
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "private" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private.id
}

resource "aws_subnet" "db" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
}

resource "aws_route_table" "db" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "db" {
  route_table_id = aws_route_table.db.id
  subnet_id      = aws_subnet.db.id
}
