resource "aws_wafv2_ip_set" "ngpos-test-ipset" {
  name               = "${var.waf_name_prefix}-ipset"
  description        = "IP sets for ngpos test environment"
  scope              = var.scope
  ip_address_version = "IPV4"
  addresses          = var.cidr_ip_range

  tags = {
    Name = "${var.waf_name_prefix}-ipset"

  }
}


resource "aws_wafv2_web_acl" "ngpos-test-waf-webacl" {
  name        = "${var.waf_name_prefix}-webacl"
  description = "Web Acl for the X-forwarder Rule"
  scope       = var.scope


  default_action {
    block {
      custom_response {
        response_code            = "403"
        custom_response_body_key = "403_key"
      }

    }

  }


  custom_response_body {
    key          = "403_key"
    content      = "forbidden access"
    content_type = "TEXT_PLAIN"
  }

  rule {
    name     = "${var.waf_name_prefix}-rule"
    priority = 1

    action {
      allow {}
    }


    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.ngpos-test-ipset.arn
        ip_set_forwarded_ip_config {
          fallback_behavior = "NO_MATCH"
          header_name       = "X-Forwarded-For"
          position          = "ANY"
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "${var.waf_name_prefix}-rule"
      sampled_requests_enabled   = false
    }
  }


  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "${var.waf_name_prefix}-acl"
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_web_acl_association" "alb_association" {
  depends_on   = [aws_wafv2_web_acl.ngpos-test-waf-webacl, aws_lb.ngpos-alb]
  resource_arn = aws_lb.ngpos-alb.arn
  web_acl_arn  = aws_wafv2_web_acl.ngpos-test-waf-webacl.arn
}


resource "aws_cloudwatch_log_group" "ngpos-test-waf" {
  name = "aws-waf-logs-group"
  tags = {
    Name = "${var.waf_name_prefix}"
  }
}

resource "aws_wafv2_web_acl_logging_configuration" "example" {
  log_destination_configs = ["${aws_cloudwatch_log_group.ngpos-test-waf.arn}"]
  resource_arn            = "${aws_wafv2_web_acl.ngpos-test-waf-webacl.arn}"
}
