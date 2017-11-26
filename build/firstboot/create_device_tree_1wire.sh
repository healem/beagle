#!/bin/bash

cd /root
dtc -O dtb -o BB-1WIRE-P9-22-00A0.dtbo -b 0 -@ BB-1WIRE-P9-22.dts
mv BB-1WIRE-P9-22-00A0.dtbo /lib/firmware/