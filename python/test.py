import re

import requests
from bs4 import BeautifulSoup


import json

data = {
    'name' : 'ACME',
    'shares' : 100,
    'price' : 542.23
}


json_str = json.dumps(data)

pattern = re.compile(r'adf[abcd]')


match = pattern.match('adfdc')

if match:
    print(match.group())