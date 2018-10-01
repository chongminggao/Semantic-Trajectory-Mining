import re
import json
import requests




ak = 'sbPcs1Tv41thbeokjelsjVjYdB0dOdbl'
latLong = '39.985672,116.349822'


url = 'http://api.map.baidu.com/geocoder/v2/?callback=renderReverse&location=' + latLong + '&output=json&pois=1&ak=' + ak

r = requests.get(url)
text = r.text

pattern = re.compile(r'renderReverse&&renderReverse\((.*)\)')

r = pattern.match(text)
if r:
    text = r.group(1)
    data = json.load(r.group(1))
    print(r.group(1))


