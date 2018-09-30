#
# Be sure to run `pod lib lint MagiEye.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MagiEye'
  s.version          = '0.1.0'
  s.summary          = 'Automaticly display Log,Crash,Network,ANR,Leak,CPU,RAM,FPS,NetFlow,Folder and etc with one line of code based on Swift. Just like magic eyes'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Automaticly display Log,Crash,Network,ANR,Leak,CPU,RAM,FPS,NetFlow,Folder and etc with one line of code based on Swift. Just like magic eyes...
                       DESC

  s.homepage         = 'https://github.com/AnRanScheme/MagiEye'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'AnRanScheme' => '541437674@qq.com' }
  s.source           = { :git => 'https://github.com/AnRanScheme/MagiEye.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/<AnRanScheme>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'MagiEye/Classes/**/*'
  
  s.resource_bundles = {
     'MagiEye' => ['MagiEye/Assets/*.png']
  }
 
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  # s.dependency 'AppBaseKit', '~> 0.2.2'
  # s.dependency 'Log4G', '~> 0.2.2'
  # s.dependency 'AppSwizzle', '~> 1.1.2'
  # s.dependency 'AssistiveButton', '~> 1.1.2'
  
  # s.dependency 'ASLEye', '~> 1.1.1'
  # s.dependency 'CrashEye', '~> 1.1.2'
  # s.dependency 'ANREye', '~> 1.1.1'
  # s.dependency 'SystemEye', '~> 0.2.2'
  # s.dependency 'NetworkEye.swift', '~> 1.1.3'
  # s.dependency 'LeakEye', '~> 1.1.3'
  
  # s.dependency 'FileBrowser', '~> 0.2.0'
  # s.dependency 'SwViewCapture', '~> 1.0.6'
  # s.dependency 'SQLite.swift', '~> 0.11.1'
  # s.dependency 'ESPullToRefresh', '~> 2.6'
end
