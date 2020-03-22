#!/usr/bin/env python
import socket
import subprocess
import sys
from datetime import datetime

# Clear the screen
subprocess.call('clear', shell=True)

# Ask for input
remoteServer    = input("Enter a remote host to scan: ")
firstPort   = input("Enter the first port to scan: ")
lastPort    = input("Enter the last port to scan: ")
remoteServerIP  = socket.gethostbyname(remoteServer)
int_firstPort = int(firstPort)
int_lastPort = int(lastPort)

if int_lastPort > 65535:
    print('So many ports do not exsist!')
    sys.exit()


# Print a nice banner with information on which host we are about to scan
print("-" * 80)
print('Please wait, scanning remote host {0} om {1} '.format(remoteServerIP, datetime.now()))
print("-" * 80)

# Check what time the scan started
t1 = datetime.now()
countOpenPort = 0

try:
    for port in range(int_firstPort,int_lastPort):  
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        result = sock.connect_ex((remoteServerIP, port))
        print('Testing port: ',port ,end='\r')
        if result == 0:
            print('             Port {0}:    Open'.format(port), end='\n')
            countOpenPort += 1
        sock.close()

except KeyboardInterrupt:
    print("You pressed Ctrl+C")
    sys.exit()

except socket.gaierror:
    print('Hostname could not be resolved. Exiting')
    sys.exit()

except socket.error:
    print("Couldn't connect to server")
    sys.exit()

# Checking the time again
t2 = datetime.now()

# Calculates the difference of time, to see how long it took to run the script
total =  t2 - t1

# Printing the information to screen
print('-' * 80)
print('Scanning Completed in: {0} seconden'.format(total))
print('In total {0} open ports found.'.format(countOpenPort))
print('-' * 80)
