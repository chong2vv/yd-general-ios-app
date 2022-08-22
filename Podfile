#pod 源
source 'https://github.com/CocoaPods/Specs.git'

#私有pod
platform :ios, '10.0'

def sharePods
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!
  
  #腾讯bugly
  pod 'Bugly', '2.5.0'
  pod 'Masonry'
  pod 'ReactiveObjC', '~> 3.1.0'
  pod 'MJRefresh'
  pod 'IQKeyboardManager'
  #tabbar库
  pod 'CYLTabBarController'
  #富文本label
  pod 'M80AttributedLabel', '~> 1.9.9'
  pod 'YYModel'
  pod 'YYImage'
  pod 'YYWebImage'
  pod 'SVProgressHUD'
  pod 'SDWebImage', '~> 5.8.4'
  pod 'FMDB'
  #Facebook的fishhook库，现在iOS15有崩溃，待修改
  pod 'fishhook'
  #ZF播放器
  pod 'ZFPlayer', '~> 4.0.2'
  pod 'ZFPlayer/ControlView', '~> 4.0.2'
  pod 'ZFPlayer/ijkplayer', '~> 4.0.2'
  pod 'ZFPlayer/AVPlayer', '~> 4.0.2'
  #js桥接库
  pod 'WebViewJavascriptBridge', '~> 6.0'
  #网络库，log可以考虑使用这个上传，可以根据自己项目来
  pod "WHCNetWorkKit", "~> 0.0.3"
  #解压库
  pod 'SSZipArchive'
  #腾讯存储
  pod 'MMKV'
  #二维码
  pod 'SGQRCode', '~> 3.5.1'
  #拖拽浮层view
  pod 'WMDragView', '~> 1.0.1'
  #segment库
  pod 'JXCategoryView', '1.6.1', :modular_headers => false
  #图片选择库
  pod 'TZImagePickerController' # Full version with all features
  #gif动画库
  pod 'FLAnimatedImage', '~> 1.0.17'
  #小红点库
  pod 'WZLBadge'
  
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
  pod 'YDSVProgressHUD', '~> 0.1.5'
  #图片服务
  pod 'YDImageService', '~> 0.1.2'
  #block分类库
  pod 'YDBlockKit', '~> 0.1.0'
  #ktv封装库，视频预加载
  pod 'YDPreLoader', '~> 0.1.0'
  #Alert库
  pod 'YDAlertAction', '~> 0.1.0'
  #金山云播放器二次封装
  # Pods for SIMULATOR: , :configurations => 'Release'
  pod 'KSMediaPlayerService', '~> 1.0.4', :configurations => 'Release'
  
end


def testPods
  pod 'DoraemonKit/Core', '~> 3.0.4'
  pod 'DoraemonKit/WithLogger', '~> 3.0.4'
  pod 'DoraemonKit/WithGPS', '~> 3.0.4'
  pod 'DoraemonKit/WithLoad', '~> 3.0.4'
  #内存检测工具
end



target 'yd-general-ios-app' do
  sharePods
end

target 'yd-general-ios-app-dev' do
  sharePods
  testPods
end



post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      config.build_settings['APPLICATION_EXTENSION_API_ONLY'] = 'NO'
    end
  end
end
