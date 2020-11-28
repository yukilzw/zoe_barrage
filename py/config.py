'''
@Desc: 配置文件
'''
import os
import cv2

VIDEO_NAME = 'source.mp4'     # 处理的视频文件名
FACE_KEY = 'SgogTB9ZpBLwcEYAG4AXu4MkbNookgnJ'          # 免费的识别key
FACE_SECRET = '2_lrgs8L1qjXf4by_Yi20CNcG3LtIYDc'       # 免费的密钥

dirPath = os.path.dirname(os.path.abspath(__file__))
cap = cv2.VideoCapture(os.path.join(dirPath, VIDEO_NAME))
FPS = round(cap.get(cv2.CAP_PROP_FPS), 0)

# 进行识别的关键帧，FPS每上升30，关键帧间隔+1（保证flutter在重绘蒙版时的性能的一致性）
FRAME_CD = max(1, round(FPS / 30))

if cv2.CAP_PROP_FRAME_COUNT / FRAME_CD >= 900:
    raise Warning('经计算你的视频关键帧已经超过了900，建议减少视频时长或FPS帧率！')
