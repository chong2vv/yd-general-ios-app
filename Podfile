#pod 源
source 'https://github.com/CocoaPods/Specs.git'

#私有pod
platform :ios, '10.0'

def sharePods
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!
  
  pod 'Bugly', '2.5.0'
  pod 'Masonry'
  pod 'ReactiveObjC', '~> 3.1.0'
  pod 'MJRefresh'
  pod 'IQKeyboardManager'
  pod 'lottie-ios', '~> 2.5.2'
  pod 'CYLTabBarController'
  pod 'M80AttributedLabel', '~> 1.9.9'
  pod 'YYModel'
  pod 'SVProgressHUD'
  pod 'SDWebImage', '~> 5.8.4'
  
  #YDKit
  pod 'YDAvoidCrashKit', '~> 0.1.2'
  pod 'YDUtilKit', '~> 0.0.5'
  pod 'YDNetworkManager', '~> 0.0.5'
  
end


def testPods
  pod 'DoraemonKit/Core', '~> 3.0.4'
  pod 'DoraemonKit/WithLogger', '~> 3.0.4'
  pod 'DoraemonKit/WithGPS', '~> 3.0.4'
  pod 'DoraemonKit/WithLoad', '~> 3.0.4'
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
