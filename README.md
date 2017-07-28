# ZhongLe(众乐)

>独乐乐不如众乐(yue)乐(yue)

空闲练手做的一个音乐播放器，献给美丽可爱正能量的安同学～～


#### 歌曲来源

KuGouSongs.py是爬取酷狗音乐的脚本。因为网易音乐、虾米音乐等爬到的mp3文件都是缓存服务器上的，有效期大概半个小时。好在酷狗有效期有一天，良心企业啊！ 
爬虫用的不溜，写的很粗糙！有更好更优美的方案欢迎分享！
**运行项目之前 先执行一下这个脚本（环境自配）。**

#### 项目架构

一目了然！
主要控制逻辑在Manager目录：
>ZLPlayingManager: 管理播放行为的类
>ZLPlayingQueueManager: 管理播放列表以及播放顺序的类
>ZLDownLoadManager: 管理下载任务的类 

#### 维护

目前有很多不完整不完全的地方，有时间继续优化！也欢迎大家拍砖，无论是功能设计、UI设计、代码设计模式上都可以提意见！

#### 效果图

##### 全部歌曲

![全部歌曲](http://upload-images.jianshu.io/upload_images/1136939-9834114f2220d970.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/h/640)

##### 已下载歌曲

![已下载歌曲](http://upload-images.jianshu.io/upload_images/1136939-a0580b934a0ea3df.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/h/640)

##### 播放页面

![播放页面](http://upload-images.jianshu.io/upload_images/1136939-ffb3fc8a1d1978ad.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/h/640)

##### 开始下载

![开始下载](http://upload-images.jianshu.io/upload_images/1136939-4a46f5454d1c66ab.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/h/640)

##### 删除下载

![删除下载](http://upload-images.jianshu.io/upload_images/1136939-49825f5c6127e994.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/h/640)

