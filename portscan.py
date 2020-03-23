#!/usr/bin/env python3
# Port scan corona time
# E.A. Vagevuur

import time
import socket
import ipaddress
import sys
import subprocess
from datetime import datetime

# Clear the screen
subprocess.call('clear', shell=True)

def scanHost(host):
    global int_firstPort, int_lastPort, countOpenPort
    print('Nu host {0}'.format(host))
    try:
        for port in range(int_firstPort, int_lastPort):
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            result = sock.connect_ex((host, port))
            print('Testing port: {0}'.format(port), end='\r')
            if result == 0:
                print('  Port ----> {0:>10}: Open'.format(port), end='\n')
                countOpenPort += 1
            sock.close()

    finally:
        return 0 


def isRealNetwork(target):
    # First is the network a real network
    net = ipaddress.ip_network(target)
    if '/' in target:
        try:
            if ipaddress.ip_network(target):
                print('yes network')
                return 

        except ipaddres.ip_network.ValueError:
            print('Not an network')
            sys.exit()

    else:
        print('Single host')
        return


def networkYesNo(target):
    global numberOfHosts
    net = ipaddress.ip_network(target)
    if '/' in target:
        numberOfHosts = (net.num_addresses - 2 )
        for target in net.hosts():
            target = str(target)
            hostIpAddress = socket.gethostbyname(target)
            time.sleep(2)
            scanHost(target)

    else:
        hostIpAddress = socket.gethostbyname(target)
        scanHost(target)

# Variable
countOpenPort = 0

# Ask for ipaddressen
target = input('Enter a host of network: ')
firstPort = input('Enter the first port to scan: ')
lastPort = input('Enter the last port to scan: ')
int_firstPort = int(firstPort)
int_lastPort = int(lastPort)

if int_firstPort < 1:
    print('Port number is greater than zero! You dit enter {0}'.format(int_firstPort))
    sys.exit()

if int_lastPort > 65535:
    print('There are not {0} ports in an computer!'.format(int_lastPort))
    sys.exit()

if int_firstPort > int_lastPort:
    print('Your first port {0} is greater than the last port {1}'.format(int_firstPort, int_lastPort))
    sys.exit()

isRealNetwork(target)
networkYesNo(target)

