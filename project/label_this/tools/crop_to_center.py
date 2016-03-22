from PIL import Image, ExifTags
import os
import sys
import traceback
import pprint

def crop(filename):
    try :
        original = Image.open(os.path.join(filename))
        width, height = original.size   # Get dimensions

        w = 1200
        top = (height - w) / 2
        bottom = height - top
        left = (width - w) / 2
        right = (width - left)
        
        cropped_example = original.crop((int(left), int(top), int(right), int(bottom)))
        cropped_example = cropped_example.resize((200,200), resample=Image.ANTIALIAS)
        outdir = 'thumbs/' + filename
        cropped_example.save(outdir)
        
    except:
        traceback.print_exc()

    
if __name__ == '__main__':

    img = sys.argv[1]
    crop(img)
    
    
