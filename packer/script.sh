#!/bin/bash

    sudo yum -y install httpd
    sudo yum install -y mod_ssl
    sudo systemctl start httpd
    sudo systemctl enable httpd

