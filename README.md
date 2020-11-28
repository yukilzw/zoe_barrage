### Flutter AI智能弹幕来袭~
![flutter](https://img.shields.io/badge/flutter-1.22-52c6f9.svg) ![python](https://img.shields.io/badge/python-3.8-407daf.svg) ![android](https://img.shields.io/badge/android✔-brightgreen.svg) ![ios](https://img.shields.io/badge/ios✔-green.svg)

`flutter run --release`离线运行体验<br/>

`./py`路径下包含视频帧处理脚本源码，处理后的结果已导出`res.json`文件，flutter构建时会打包进去<br/>

如果想预处理自己导入的视频（因为是离线演示，体积最好不要超过5M）：
1. 确保本地有`python3.6+`环境
2. 根目录下安装依赖`pip install -r ./py/requirements.txt -i https://mirrors.aliyun.com/pypi/simple`（国内请使用阿里云镜像，mac下请加`sudo`管理员前缀）
3. 将视频放入`./py`目录，修改`config.py`中的`VIDEO_NAME`配置为你的视频文件名
4. 根目录下依次运行脚本：
  - `python ./py/1.frames.py`
  - `python ./py/2.discern.py`
  - `python ./py/3.translate.py`
5. 最后打包前记得替换一下dart代码中的assets文件名

#### 效果截图
<table>
    <tr>
        <td >
          <img src="http://r.photo.store.qq.com/psc?/V14dALyK4PrHuj/TmEUgtj9EK6.7V8ajmQrEGTk27NqsrEznkUQAEKow65QUFQx.il0LCj2geuUVZS*JIQA3jhW23Vt0T3fLcl6ge6Iq6y4GMEdrhJPweEdxac!/r" width="320">
        </td>
        <td >
          <img src="http://r.photo.store.qq.com/psc?/V14dALyK4PrHuj/TmEUgtj9EK6.7V8ajmQrENPJuk*SWGwtGl85IRDTqyo3oPYnOESVaA6SlDHLMFOVT7OPGwGnqRea.VRUGLKjiUMoSnWMOSX*7qYbJxKGQtk!/r" width="320">
        </td>
    </tr>
    <tr>
       <td >
          <img src="http://r.photo.store.qq.com/psc?/V14dALyK4PrHuj/TmEUgtj9EK6.7V8ajmQrEOUE90nZREmYHZZJPPg7SMJxy6qewT35ZW8tJ8jGJLzEDvDCpW6MHlp78gsAdXj6QaO2Y9FcDULSQ8u7.KOjKcM!/r" width="320">
        </td>
        <td >
          <img src="http://r.photo.store.qq.com/psc?/V14dALyK4PrHuj/TmEUgtj9EK6.7V8ajmQrEBIKuY7Uj6O0Po6l4zAzzz4cS0yvzyj9piGMHeEGOx*JlcSbKlShBccuRpt0fAgbwZztVZG4F4Ai47R8ex2VfTM!/r" width="320">
        </td>
    </tr>
</table>
