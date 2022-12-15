#! /bin/bash
sudo dfu-programmer at89c5131 erase
sudo dfu-programmer at89c5131 flash $1
