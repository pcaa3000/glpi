#!/bin/bash -e

echo '[mysqld]
default-time-zone=America/Lima
' > /etc/mysql/conf.d/timezone.cnf
