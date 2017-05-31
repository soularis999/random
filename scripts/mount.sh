#! /usr/bin/env bash

sudo mount -t cifs //$1/ /mnt/ -o username=test,setuids,noperm
