#!/bin/bash

#The Coolbits value is the sum of its component bits in the binary numeral system. The component bits are:
#1 (bit 0) - Enables overclocking of older (pre-Fermi) cores on the Clock Frequencies page in nvidia-settings.
#2 (bit 1) - When this bit is set, the driver will "attempt to initialize SLI when using GPUs with different amounts of video memory".
#4 (bit 2) - Enables manual configuration of GPU fan speed on the Thermal Monitor page in nvidia-settings.
#8 (bit 3) - Enables overclocking on the PowerMizer page in nvidia-settings. Available since version 337.12 for the Fermi architecture and newer.[2]
#16 (bit 4) - Enables overvoltage using nvidia-settings CLI options. Available since version 346.16 for the Fermi architecture and newer.[3]

nvidia-xconfig --enable-all-gpus
nvidia-xconfig --cool-bits=12
