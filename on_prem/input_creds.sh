#!/bin/bash
echo "Enter your vSphere creds:"
echo "-------------------------"
echo -n "Username: "
read username
echo -n "Password: "
read -s password
export TF_VAR_password=$password
export TF_VAR_username=$username
