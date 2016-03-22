from PIL import Image, ExifTags
import os
import sys
import traceback
import pprint

def rotate(filename):
    try :
        image=Image.open(os.path.join(filename))
        for orientation in ExifTags.TAGS.keys() : 
            if ExifTags.TAGS[orientation]=='Orientation' : break

        exif=dict(image._getexif().items())
        if   exif[orientation] == 3 : 
            image=image.rotate(180, expand=True)
        elif exif[orientation] == 6 : 
            image=image.rotate(270, expand=True)
        elif exif[orientation] == 8 : 
            image=image.rotate(90, expand=True)
        print("Rotating {}".format(filename))
        image.save(os.path.join(filename))

    except:
        #traceback.print_exc()
        pass
    
if __name__ == '__main__':

    img = sys.argv[1]
    rotate(img)
    
    
