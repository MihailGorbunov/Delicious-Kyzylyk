#!/bin/bash

sudo rm -rf connection/
sudo rm -rf xray/
sudo docker container prune
sudo docker volume rm xray-xtls-docker_xray_mount 
