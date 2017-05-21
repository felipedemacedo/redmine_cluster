#!/bin/bash

docker build -t felipederodrigues/redmine_cluster:latest .
docker build -t felipederodrigues/redmine_cluster:latest_postfix ./postfix
docker build -t felipederodrigues/redmine_cluster:passenger ./passenger
docker build -t felipederodrigues/redmine_cluster:passenger_postfix ./passenger/postfix