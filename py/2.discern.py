'''
@Desc: 调用算法接口返回人体模型灰度图
'''
import os
import shutil
import base64
import re
import json
import threading
import requests
import config

dirPath = os.path.dirname(os.path.abspath(__file__))
clip_path = dirPath + '/clip'

if not os.path.exists(clip_path):
    os.makedirs(clip_path)

# 图像识别类
class multiple_req:
    reqTimes = 0
    filename = None
    data = {
        'api_key': config.FACE_KEY,
        'api_secret': config.FACE_SECRET,
        'return_grayscale': 1
    }

    def __init__(self, filename):
        self.filename = filename

    def once_again(self):
        # 成功率大约10%，记录一下被限流失败的次数 :)
        self.reqTimes += 1
        print(self.filename +' fail times:' + str(self.reqTimes))
        return self.reqfaceplus()

    def reqfaceplus(self):
        abs_path_name = os.path.join(dirPath, 'images', self.filename)
        # 图片以二进制提交
        files = {'image_file': open(abs_path_name, 'rb')}
        try:
            response = requests.post(
                'https://api-cn.faceplusplus.com/humanbodypp/v2/segment', data=self.data, files=files)
            res_data = json.loads(response.text)

            # 免费的API 很大概率被限流返回失败，这里递归调用，一直到这个图片成功识别后返回
            if 'error_message' in res_data:
                return self.once_again()
            else:
                # 识别成功返回结果
                return res_data
        except requests.exceptions.RequestException as e:
            return self.once_again()

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
has_cliped_list = os.listdir(clip_path)
for n in image_list_sort:
    if 'clip-' + n in has_cliped_list and 'clip-color-' + n in has_cliped_list:
        continue
    '''
    为每帧图片起一个单独的线程来递归调用，达到并行效果。所有图片被识别保存完毕后退出主进程，此过程需要几分钟。
    （这里每个线程中都是不断地递归网络请求、挂起等待、IO写入，不占用CPU）
    '''
    t = threading.Thread(target=thread_req, name=n, args=[n])
    t.start()
