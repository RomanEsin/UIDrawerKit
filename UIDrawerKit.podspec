#
# Be sure to run `pod lib lint UIDrawerKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UIDrawerKit'
  s.version          = '1.0.0'
  s.summary          = 'A drawer like in `Shortcuts` app and some others. Its fast and easy to use. For more info read README.md'
  s.description      = 'Read README.md'

  s.homepage         = 'https://github.com/RomanEsin/UIDrawerKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Roman Esin' => 'esinromanswift@gmail.com' }
  s.source           = { :git => 'https://github.com/RomanEsin/UIDrawerKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/EsinRomanSwift

  s.ios.deployment_target = '12.0'

  s.source_files = 'UIDrawerKit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'UIDrawerKit' => ['UIDrawerKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.framework = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
