<p align="center"><a href="#" target="_blank" rel="noopener noreferrer"><img width="125" src="http://r.photo.store.qq.com/psc?/V14dALyK4PrHuj/TmEUgtj9EK6.7V8ajmQrEKy7VajsOCFgjQH7rqAvNvwJDnYfDo5lhLXSf0A0.2Wep.NiTs2kUCvsQ8XqoTYUG2d.ZVP9v*YiDxK6SjeuwxI!/r" alt="Zoe barrage"></a></p>

<p align="center">
  <img src="https://img.shields.io/badge/flutter-1.22-52c6f9.svg?sanitize=true" alt="Build Status">
  <img src="https://img.shields.io/badge/python-3.8-407daf.svg?sanitize=true" alt="Coverage Status">
  <img src="https://img.shields.io/badge/android✔-brightgreen.svg?sanitize=true" alt="Downloads">
  <img src="https://img.shields.io/badge/ios✔-green.svg?sanitize=true" alt="Version">
</p>

<h2 align="center">Flutter~Python AI弹幕播放器来袭！</h2>

`flutter run --release`构建正式包体验<br/>

`./py`路径下包含视频帧处理脚本源码，处理后的结果已导出`res.json`文件，flutter构建时会打包进去<br/>

如果想预处理自己导入的视频（因为是离线演示，体积最好不要超过5M）：
1. 确保本地有`python3.6+`环境
2. 根目录下安装依赖`pip install -r ./py/requirements.txt -i https://mirrors.aliyun.com/pypi/simple`（国内请使用阿里云镜像，mac下请加`sudo`管理员前缀）
3. 将视频放入`./py`目录，修改视频文件名为`source.mp4`
4. 根目录下依次运行脚本：
  - `python ./py/1.frames.py`
  - `python ./py/2.discern.py`
  - `python ./py/3.translate.py`
  
完整实现教程可见文章：<a href="https://www.jianshu.com/p/716ea7714b47" target="_blank">Flutter AI 智能弹幕播放器 — 简书·心动音符</a>

#### APP效果预览
IPhone运行时录屏：<a href="https://www.bilibili.com/video/BV1Mp4y1z7ud" target="_blank">戳这里观看</a><br/>
<img src="http://r.photo.store.qq.com/psc?/V14dALyK4PrHuj/TmEUgtj9EK6.7V8ajmQrEDPNK2CMseiaC90T2dhhO9lrkR49Z36HLgG5YLex5LL9gF4jvovk.hJp7opYTq0YgiI2ys7NwBdZwFPItV*nR8c!/r" alt="android & ios ScreenShot">
<table>
    <tr>
        <td >
          <img src="http://r.photo.store.qq.com/psc?/V14dALyK4PrHuj/TmEUgtj9EK6.7V8ajmQrENPJuk*SWGwtGl85IRDTqyo3oPYnOESVaA6SlDHLMFOVT7OPGwGnqRea.VRUGLKjiUMoSnWMOSX*7qYbJxKGQtk!/r" width="100%">
        </td>
        <td >
          <img src="http://r.photo.store.qq.com/psc?/V14dALyK4PrHuj/TmEUgtj9EK6.7V8ajmQrEOUE90nZREmYHZZJPPg7SMJxy6qewT35ZW8tJ8jGJLzEDvDCpW6MHlp78gsAdXj6QaO2Y9FcDULSQ8u7.KOjKcM!/r" width="100%">
        </td>
        <td >
          <img src="http://r.photo.store.qq.com/psc?/V14dALyK4PrHuj/TmEUgtj9EK6.7V8ajmQrEBIKuY7Uj6O0Po6l4zAzzz4cS0yvzyj9piGMHeEGOx*JlcSbKlShBccuRpt0fAgbwZztVZG4F4Ai47R8ex2VfTM!/r" width="100%">
        </td>
    </tr>
</table>
