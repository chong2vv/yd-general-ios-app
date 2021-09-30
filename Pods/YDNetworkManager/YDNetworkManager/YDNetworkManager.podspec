#
#  Be sure to run `pod spec lint YDNetworkManager.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "YDNetworkManager"
  spec.version      = "0.0.5"
  spec.summary      = "YD 的网络请求库，基于YTK、AF"
  spec.platform     = :ios, "9.0"
  spec.homepage     = "https://github.com/chong2vv/YDNetwrokManager"

  spec.license      = "MIT"

  spec.author             = { "王远东" => "chong2vv@gmail.com" }

  spec.source       = { :git => "https://github.com/chong2vv/YDNetwrokManager.git", :tag => "#{spec.version}" }
  spec.source_files = "YDNetworkManager/**/*"

  spec.static_framework = true
  spec.requires_arc = true
  spec.frameworks = "Foundation", "UIKit"
  spec.dependency 'YTKNetwork'
end
