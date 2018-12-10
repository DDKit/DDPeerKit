#
# Be sure to run `pod lib lint DDPeerKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DDPeerKit'
  s.version          = '1.0.0'
  s.summary          = '基于 MultipeerConnectivity 的二次封装'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  基于 MultipeerConnectivity 的二次封装
  基于 MultipeerConnectivity 的二次封装
  DESC

  s.homepage         = 'https://github.com/DDKit/DDPeerKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'duanchanghe@gmail.com' => 'DDKit' }
  s.source           = { :git => 'https://github.com/DDKit/DDPeerKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.swift_version = '4.2'
  s.source_files = 'DDPeerKit/Classes/**/*'
  
  
  # s.resource_bundles = {
  #   'DDPeerKit' => ['DDPeerKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'MultipeerConnectivity'
  # s.dependency 'AFNetworking', '~> 2.3'
end
