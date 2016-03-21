import io
import os

import csvkit
import requests
from PIL import Image

raw = 'raw-manifest.csv'

URL_BASE = 'http://imgarc.lib.ucdavis.edu/images/winelabels/'
THUMB_SUFFIX = '--thumb'
FILE_SUFFIX = '.jpg'
OUTPUT_DIR = 'subjects/'
OUTPUT_FIELDS = ('order', 'file_path', 'thumbnail', 'width', 'height')
MEDIA_DIR = 'raw/'

output_file = OUTPUT_DIR + 'group_labels.csv'
output_csv = csvkit.writer(open(output_file, 'w'))
output_csv.writerow(OUTPUT_FIELDS)

for f in csvkit.reader(open(raw)):
    order, base, caption, title, sublocation = f
    filename = base.replace('.dng', '')
    url = URL_BASE + filename + FILE_SUFFIX
    thumbnail = URL_BASE + filename + THUMB_SUFFIX + FILE_SUFFIX
    
    # Get the width/height of the image
    print("Processing " + str(url))

    # Check locally first
    local_filename = MEDIA_DIR + filename + FILE_SUFFIX  
    if os.path.exists(local_filename):
        temp_f = open(local_filename, 'rb')
    else:
        temp_f = io.BytesIO(requests.get(url).content)
        
    im = Image.open(temp_f)
    width, height = im.size
    if not os.path.exists(local_filename):
        im.save(local_filename)
    
    output_csv.writerow((order, url, thumbnail, width, height))


