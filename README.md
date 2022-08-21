# yd-general-ios-app
## yd-general-ios-app iOS基础工程介绍

yd-general-ios-app是封装了一些常用工具的基础工程，包含几个常用的三方库及多个YD库，旨在快速搭建项目。本项目是根据作者之前的一些项目而封装的，各位使用的同学在使用过程中还要根据自己实际的需求进行构建。

本项目所封装的YD库有以下几个：

```
  #YDKit
  #防崩溃、日志、安全线程库
  pod 'YDAvoidCrashKit', '~> 0.1.8'
  #工具类
  pod 'YDUtilKit', '~> 0.0.7'
  #网络请求库
  pod 'YDNetworkManager', '~> 0.0.5'
  #权限申请库
  pod 'YDAuthorizationUtil', '~> 0.1.0'
  #文件管理器
  pod 'YDFileManager', '~> 0.1.3'
  #缓存清理
  pod 'YDClearCacheService', '~> 0.1.0'
  #路由
  pod 'YDRouter', '~> 0.1.0'
  pod 'YDMediator', '~> 0.1.1'
  #加载loading库
  pod 'YDSVProgressHUD', '~> 0.1.4'
  #图片服务
  pod 'YDImageService', '~> 0.1.2'
  #金山云播放器二次封装
  # Pods for SIMULATOR: , :configurations => 'Release'
  pod 'KSMediaPlayerService', '~> 1.0.4', :configurations => 'Release'
```

## 安装及使用方式
clone工程后进行pod install 即可

### 使用方法

#### YDAvoidCrash 防崩溃库使用


## 更新


## 写在最后的话
一个人的精力是有限的，如果你发现了哪些比较好用的辅助库，而这个框架中没有进行处理，希望你能 issue, 我将添加到yd-general-ios-app中，同时在使用过程中发现BUG或者有更好的解决方法也同样欢迎你能issue，我将万分感谢！
