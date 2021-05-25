import requests
import json
import base64

url = 'http://2d20c4ef39bd.ngrok.io/predict'
file_path = 'data/test/cloth/000003_1.jpg'

data = {}
with open(file_path , mode='rb') as file:
    img = file.read()
data['img'] = base64.encodebytes(img).decode('utf-8')

res = requests.post(url, json=json.dumps(data))

print(res)
if res.ok:
	with open("image.jpg", "wb") as fp:
	    content = base64.b64decode(res.json()['img'])
	    fp.write(content)
	    
