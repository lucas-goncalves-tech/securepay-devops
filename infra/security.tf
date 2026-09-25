# resource "aws_security_group" "alb" {
#   name        = "securepay-alb-sg"
#   description = "Regras de acesso para Load Balancer"
#   vpc_id      = aws_vpc.main.id
# }

resource "aws_security_group" "api" {
  name        = "securepay-api-sg"
  description = "Regras de acesso para API"
  vpc_id      = aws_vpc.main.id
}
resource "aws_security_group" "db" {
  name        = "securepay-db-sg"
  description = "Regras de acesso para Database"
  vpc_id      = aws_vpc.main.id
}

# --- ALB
# resource "aws_vpc_security_group_ingress_rule" "alb_https_in" {
#   description       = "Internet -> ALB:443"
#   security_group_id = aws_security_group.alb.id
#   from_port         = 443
#   to_port           = 443
#   cidr_ipv4 = "0.0.0.0/0"
#   ip_protocol       = "tcp"
# }
#
# resource "aws_vpc_security_group_ingress_rule" "alb_http_in" {
#   description       = "Internet -> ALB:80"
#   security_group_id = aws_security_group.alb.id
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = 80
#   to_port           = 80
#   ip_protocol       = "tcp"
# }
#
# resource "aws_vpc_security_group_egress_rule" "alb_to_api" {
#   description = "ALB -> API:8080"
#   security_group_id = aws_security_group.alb.id
#   referenced_security_group_id = aws_security_group.api.id
#   ip_protocol       = "tcp"
#   from_port = 8080
#   to_port = 8080
# }

# --- API

resource "aws_vpc_security_group_ingress_rule" "api_http_in" {
  description       = "INTERNET -> API:80"
  security_group_id = aws_security_group.api.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "api_https_in" {
  description       = "INTERNET -> API:433"
  security_group_id = aws_security_group.api.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "api_to_db" {
  description                  = "API -> DB:5432"
  security_group_id            = aws_security_group.api.id
  referenced_security_group_id = aws_security_group.db.id
  ip_protocol                  = "tcp"
  from_port                    = 5432
  to_port                      = 5432
}

# --- DB

resource "aws_vpc_security_group_ingress_rule" "db_from_api" {
  description                  = "DB:5432 <- API"
  security_group_id            = aws_security_group.db.id
  referenced_security_group_id = aws_security_group.api.id
  ip_protocol                  = "tcp"
  from_port                    = 5432
  to_port                      = 5432
}