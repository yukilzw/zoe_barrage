'''
@Desc: 调用算法接口返回人体模型灰度图
'''
import os
import shutil
import base64
import re
import json
import time
import threading
import requests

dirPath = os.path.dirname(os.path.abspath(__file__))
clip_path = dirPath + '/clip'

if os.path.exists(clip_path):
    shutil.rmtree(clip_path)
os.makedirs(clip_path)

# 递归调用Face++图像识别类
class multiple_req:
    reqTimes = 0
    data = {
        'api_key': 'SgogTB9ZpBLwcEYAG4AXu4MkbNookgnJ',  # 这是我申请的试用KEY，不要频繁调~！
        'api_secret': '2_lrgs8L1qjXf4by_Yi20CNcG3LtIYDc',   # 这是我申请的试用秘钥，不要频繁调~！
        'return_grayscale': 1
    }

    def __init__(self, filename):
        self.filename = filename

    def reqfaceplus(self):
        abs_path_name = os.path.join(dirPath, 'images', self.filename)
        # 图片以二进制提交
        files = {'image_file': open(abs_path_name, 'rb')}
        response = requests.post('https://api-cn.faceplusplus.com/humanbodypp/v2/segment', data=self.data, files=files)
        res_data = json.loads(response.text)

        # face++免费的API key很大概率被限流返回失败，所以我们递归调用（设个CD），一直等这个图片成功识别后再切到下一张图片
        if 'error_message' in res_data:
            # 记录一下被限流失败的次数 :) 真的很多次
            self.reqTimes += 1
            print(self.filename +' fail times:' + str(self.reqTimes))
            # 等200ms继续对这个图片发起识别
            time.sleep(.2)
            return self.reqfaceplus()
        else:
            # 识别成功返回结果
            return res_data

# 多线程并行函数
def thread_req(n):
    # 创建图像识别类
    multiple_req_ins = multiple_req(filename=n)
    res = multiple_req_ins.reqfaceplus()
    # 返回结果为base64编码彩色图、灰度图
    img_data_color = base64.b64decode(res['body_image'])
    img_data = base64.b64decode(res['result'])

    with open(dirPath + '/clip/clip-color-' + n, 'wb') as f:
        # 保存彩色图片
        f.write(img_data_color)
    with open(dirPath + '/clip/clip-' + n, 'wb') as f:
        # 保存灰度图片
        f.write(img_data)
    
    print(n + ' clip saved.')


# 读取之前准备好的所有视频帧图片进行识别
image_list = os.listdir(os.path.join(dirPath, 'images'))
image_list_sort = sorted(image_list, key=lambda name: int(re.sub(r'\D', '', name)))
for n in image_list_sort:
    '''
    为每帧图片起一个单独的线程来递归调用，达到并行效果。所有图片被识别保存完毕后退出主进程，此过程需要几分钟。
    （这里每个线程中都是不断地递归网络请求、挂起等待、IO写入，不占用CPU，不用考虑GIL）
    '''
    t = threading.Thread(target=thread_req, name=n, args=[n])
    t.start()
