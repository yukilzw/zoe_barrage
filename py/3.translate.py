'''
@Desc: openCV转换灰度图 & 轮廓判定转换坐标JSON
'''
import os
import json
import re
import shutil
import cv2
import config

dirPath = os.path.dirname(os.path.abspath(__file__))
clip_path = os.path.join(dirPath, 'mask')
cap = cv2.VideoCapture(os.path.join(dirPath, config.VIDEO_NAME))
frame_width = cap.get(cv2.CAP_PROP_FRAME_WIDTH) # 分辨率（宽）
frame_height = cap.get(cv2.CAP_PROP_FRAME_HEIGHT) # 分辨率（高）
FPS = round(cap.get(cv2.CAP_PROP_FPS), 0)   # 视频FPS
mask_cd = int(1000 / FPS * config.FRAME_CD)      # 初始帧时间
milli_seconds_plus = mask_cd  # 每次递增一帧的增加时间
jsonTemp = {                          # 最后要存入的json配置
    'mask_cd': mask_cd,
    'frame_width': frame_width,
    'frame_height': frame_height
}

if os.path.exists(clip_path):
    shutil.rmtree(clip_path)
os.makedirs(clip_path)

# 输出灰度图与轮廓坐标集合
def output_clip(filename):
    global mask_cd
    # 读取原图（这里我们原图就已经是灰度图了）
    img = cv2.imread(os.path.join(dirPath, 'clip', filename))
    # 转换成灰度图（openCV必须要转换一次才能喂给下一层）
    gray_in = cv2.cvtColor(img , cv2.COLOR_BGR2GRAY)
    # 反色变换，gray_in为一个三维矩阵，代表着灰度图的色值0～255，我们将黑白对调
    gray = 255 - gray_in
    # 将灰度图转换为纯黑白图，要么是0要么是255，没有中间值
    _, binary = cv2.threshold(gray , 220 , 255 , cv2.THRESH_BINARY)
    # 保存黑白图做参考
    cv2.imwrite(clip_path + '/invert-' + filename, binary)
    # 从黑白图中识趣包围图形，形成轮廓数据
    contours, _ = cv2.findContours(binary, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
    # 解析轮廓数据存入缓存
    clip_list = []
    for item in contours:
        if item.size > 0:
            # 每个轮廓是一个三维矩阵，shape为(n, 1, 2) ，n为构成这个面的坐标数量，1没什么意义，2代表两个坐标x和y
            rows, _, __ = item.shape
            clip = []
            clip_list.append(clip)
            for i in range(rows):
                # 将np.ndarray转为list，不然后面JSON序列化解析不了
                clip.append(item[i, 0].tolist())

    millisecondsStr = str(mask_cd)
    # 将每一个轮廓信息保存到key为帧所对应时间的list
    jsonTemp[millisecondsStr] = clip_list

    print(filename + ' time(' + millisecondsStr +') data.')
    mask_cd += milli_seconds_plus

# 列举刚才算法返回的灰度图
clipFrame = []
for name in os.listdir(os.path.join(dirPath, 'clip')):
    if not re.match(r'^clip-frame', name):
        continue
    clipFrame.append(name)

# 对文件名进行排序，按照帧顺序输出
clipFrameSort = sorted(clipFrame, key=lambda name: int(re.sub(r'\D', '', name)))
for name in clipFrameSort:
    output_clip(name)

# 全部坐标提取完成后写成json提供给flutter
jsObj = json.dumps(jsonTemp)

fileObject = open(os.path.join(dirPath, 'res.json'), 'w')
fileObject.write(jsObj)
fileObject.close()

print('calc done')
