#!/bin/bash
echo -ne "\033]0;"MinerGate XMR CPU 2"\007"

. ./config.sh

cd /home/opodul/miner/cpuminer-multi
./minerd -a cryptonight -o stratum+tcp://xmr.pool.minergate.com:45560 -u $account_minergate -p x -t 2
