import requests
url = 'http://1396f0685351.ngrok.io/predict'
#f = open('cloth.jpg', 'rb')
#files = {"file": (f.name, f, "multipart/form-data")}
file_path = 'cloth.jpg'

#files = {'my_file': open('cloth.jpg', 'rb')}
#files = {'filename':file_path,'content_type':"image/jpeg",'file':open(file_path,'rb')}
#files = {'file':(file_path, open(file_path, 'rb'), "multipart/form-data")}
import json
import base64

data = {}
with open(file_path , mode='rb') as file:
    img = file.read()
data['img'] = base64.encodebytes(img).decode('utf-8')




#json_file = open(file_path,'rb').read()

res = requests.post(url, json=json.dumps(data))

print(res)

if res.ok:
    print(res.json())