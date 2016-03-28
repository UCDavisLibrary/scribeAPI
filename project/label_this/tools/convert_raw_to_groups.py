import io
import os

import csvkit
from PIL import Image

raw = 'raw-manifest.csv'

URL_BASE = '/images/labels/'
FILE_SUFFIX = '.jpg'
OUTPUT_DIR = 'subjects/'
OUTPUT_FIELDS = ('order', 'file_path', 'thumbnail', 'width', 'height', 'filenumber')
MEDIA_DIR = 'assets/images/labels/2048x/'

output_file = OUTPUT_DIR + 'group_labels.csv'
output_csv = csvkit.writer(open(output_file, 'w'))
output_csv.writerow(OUTPUT_FIELDS)

for i, f in enumerate(csvkit.reader(open(raw))):
    _, base, caption, title, sublocation = f
    order = i
    filename = base.replace('.dng', '')
    filenumber = filename.replace('Amerine-', '')
    
    file_suffix = filenumber[0]
    url = URL_BASE + "2048x/" + file_suffix + '/' + filename + FILE_SUFFIX
    thumbnail = URL_BASE + "200x/" + file_suffix + '/' + filename + FILE_SUFFIX
    
    # Get the width/height of the image
    print("Processing " + str(url))

    # Check locally first
    local_filename = MEDIA_DIR + file_suffix + '/' + filename + FILE_SUFFIX  
    try:
        temp_f = open(local_filename, 'rb')
        im = Image.open(temp_f)
        width, height = im.size
        if not os.path.exists(local_filename):
            im.save(local_filename)
    
        output_csv.writerow((order, url, thumbnail, width, height, filenumber))

    except FileNotFoundError:
        print("Skipping missing " + str(local_filename))

