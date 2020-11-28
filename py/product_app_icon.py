'''
@Desc: 自动生成APP打包图标
'''
import os
import shutil
from PIL import Image

dirPath = os.path.dirname(os.path.abspath(__file__))
outPutPath_ios = os.path.abspath(os.path.join(dirPath, '../ios/Runner/Assets.xcassets/AppIcon.appiconset/'))
outPutPath_android = os.path.abspath(os.path.join(dirPath, '../android/app/src/main/res/'))

ImageName = os.path.abspath(os.path.join(dirPath, '../zoe.png'))
originImg = ''

try:
    originImg = Image.open(ImageName)
except:
    print ('\033[31m' + '\'' + ImageName + '\'' + '，文件不存在或不是图片，请检查文件路径.' + '\033[0m')
    quit()

def create_new_path(path):
    if os.path.exists(path):
        shutil.rmtree(path)
    os.makedirs(path)
    return path

# IOS
create_new_path(outPutPath_ios)

# 20x20
img0 = originImg.resize((20,20), Image.ANTIALIAS)
img1 = originImg.resize((40,40), Image.ANTIALIAS)
img2 = originImg.resize((60,60), Image.ANTIALIAS)
img0.save(os.path.join(outPutPath_ios, 'appZoe20x20.png'),"png")
img1.save(os.path.join(outPutPath_ios, 'appZoe20x20@2x.png'),"png")
img2.save(os.path.join(outPutPath_ios, 'appZoe20x20@3x.png'),"png")

# 29x29
img3 = originImg.resize((29,29), Image.ANTIALIAS)
img4 = originImg.resize((58,58), Image.ANTIALIAS)
img5 = originImg.resize((87,87), Image.ANTIALIAS)
img3.save(os.path.join(outPutPath_ios, 'appZoe29x29.png'),"png")
img4.save(os.path.join(outPutPath_ios, 'appZoe29x29@2x.png'),"png")
img5.save(os.path.join(outPutPath_ios, 'appZoe29x29@3x.png'),"png")

# 40x40
img6 = originImg.resize((40,40), Image.ANTIALIAS)
img7 = originImg.resize((80,80), Image.ANTIALIAS)
img8 = originImg.resize((120,120), Image.ANTIALIAS)
img6.save(os.path.join(outPutPath_ios, 'appZoe40x40.png'),"png")
img7.save(os.path.join(outPutPath_ios, 'appZoe40x40@2x.png'),"png")
img8.save(os.path.join(outPutPath_ios, 'appZoe40x40@3x.png'),"png")

# 60x60
img9 = originImg.resize((120,120), Image.ANTIALIAS)
img10 = originImg.resize((180,180), Image.ANTIALIAS)
img9.save(os.path.join(outPutPath_ios, 'appZoe60x60@2x.png'),"png")
img10.save(os.path.join(outPutPath_ios, 'appZoe60x60@3x.png'),"png")

# ipad
img11 = originImg.resize((76,76), Image.ANTIALIAS)
img12 = originImg.resize((152,152), Image.ANTIALIAS)
img13 = originImg.resize((167,167), Image.ANTIALIAS)
img11.save(os.path.join(outPutPath_ios, 'appZoe76x76.png'),"png")
img12.save(os.path.join(outPutPath_ios, 'appZoe76x76@2x.png'),"png")
img13.save(os.path.join(outPutPath_ios, 'appZoe83.5x83.5@2x.png'),"png")

# 创建Contents.json文件

content = '''
{
  "images" : [
    {
      "idiom" : "iphone",
      "size" : "20x20",
      "filename" : "appZoe20x20@2x.png",
      "scale" : "2x"
    },
    {
      "idiom" : "iphone",
      "size" : "20x20",
      "filename" : "appZoe20x20@3x.png",
      "scale" : "3x"
    },
    {
      "size" : "29x29",
      "idiom" : "iphone",
      "filename" : "appZoe29x29.png",
      "scale" : "1x"
    },
    {
      "size" : "29x29",
      "idiom" : "iphone",
      "filename" : "appZoe29x29@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "29x29",
      "idiom" : "iphone",
      "filename" : "appZoe29x29@3x.png",
      "scale" : "3x"
    },
    {
      "size" : "40x40",
      "idiom" : "iphone",
      "filename" : "appZoe40x40@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "40x40",
      "idiom" : "iphone",
      "filename" : "appZoe40x40@3x.png",
      "scale" : "3x"
    },
    {
      "size" : "60x60",
      "idiom" : "iphone",
      "filename" : "appZoe60x60@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "60x60",
      "idiom" : "iphone",
      "filename" : "appZoe60x60@3x.png",
      "scale" : "3x"
    },
    {
      "idiom" : "ipad",
      "size" : "20x20",
      "filename" : "appZoe20x20.png",
      "scale" : "1x"
    },
    {
      "idiom" : "ipad",
      "size" : "20x20",
      "filename" : "appZoe20x20@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "29x29",
      "idiom" : "ipad",
      "filename" : "appZoe29x29.png",
      "scale" : "1x"
    },
    {
      "size" : "29x29",
      "idiom" : "ipad",
      "filename" : "appZoe29x29@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "40x40",
      "idiom" : "ipad",
      "filename" : "appZoe40x40.png",
      "scale" : "1x"
    },
    {
      "size" : "40x40",
      "idiom" : "ipad",
      "filename" : "appZoe40x40@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "76x76",
      "idiom" : "ipad",
      "filename" : "appZoe76x76.png",
      "scale" : "1x"
    },
    {
      "size" : "76x76",
      "idiom" : "ipad",
      "filename" : "appZoe76x76@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "83.5x83.5",
      "idiom" : "ipad",
      "filename" : "appZoe83.5x83.5@2x.png",
      "scale" : "2x"
    }
  ],
  "info" : {
    "version" : 1,
    "author" : "xcode"
  }
}
'''

f = open(os.path.join(outPutPath_ios, 'Contents.json'), 'w')
f.write(content)
f.close()

print('\033[7;32m' + 'IOS输出文件夹：' + outPutPath_ios + '\033[0m')

# 安卓
icon_name = 'zoe.png'

path1 = create_new_path(os.path.join(outPutPath_android, 'mipmap-mdpi'))
path2 = create_new_path(os.path.join(outPutPath_android, 'mipmap-hdpi'))
path3 = create_new_path(os.path.join(outPutPath_android, 'mipmap-xhdpi'))
path4 = create_new_path(os.path.join(outPutPath_android, 'mipmap-xxhdpi'))
path5 = create_new_path(os.path.join(outPutPath_android, 'mipmap-xxxhdpi'))

img14 = originImg.resize((48,48), Image.ANTIALIAS)
img15 = originImg.resize((72,72), Image.ANTIALIAS)
img16 = originImg.resize((96,96), Image.ANTIALIAS)
img17 = originImg.resize((144,144), Image.ANTIALIAS)
img18 = originImg.resize((192,192), Image.ANTIALIAS)
img14.save(os.path.join(path1, icon_name),"png")
img15.save(os.path.join(path2, icon_name),"png")
img16.save(os.path.join(path3, icon_name),"png")
img17.save(os.path.join(path4, icon_name),"png")
img18.save(os.path.join(path5, icon_name),"png")

print('\033[7;32m' + '安卓输出文件夹：' + outPutPath_android + '\033[0m')
