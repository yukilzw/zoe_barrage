'''
@Desc: 视频帧提取
'''
import os
import shutil
import cv2
import config

dirPath = os.path.dirname(os.path.abspath(__file__))
images_path = dirPath + '/images'
cap = cv2.VideoCapture(os.path.join(dirPath, config.VIDEO_NAME))
count = 1

if os.path.exists(images_path):
    shutil.rmtree(images_path)
os.makedirs(images_path)

# 循环读取视频的每一帧
while True:
    ret, frame = cap.read()    
    if ret:
        if(count % config.FRAME_CD == 0):
            print('the number of frames：' + str(count))
            # 保存截取帧到本地
            cv2.imwrite(images_path + '/frame' + str(count) + '.jpg', frame)
        count += 1
        cv2.waitKey(0)
    else:
        print('frames were created successfully')
        break

cap.release()
