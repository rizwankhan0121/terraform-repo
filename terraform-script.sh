#!/bin/bash

terraform init

terraform plan -lock=false

terraform apply -auto-approve
