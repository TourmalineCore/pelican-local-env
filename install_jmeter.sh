#! /bin/bash
apt update

apt install default-jre -y

wget https://dlcdn.apache.org//jmeter/binaries/apache-jmeter-5.6.3.tgz

tar -xzf apache-jmeter-5.6.3.tgz

npm ci

mkdir -p ./report
mkdir -p ./result
mkdir -p ./report/home-page