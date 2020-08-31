#
# Be sure to run `pod lib lint SwiftExtensionsPack.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name          = 'SwiftRegularExpression'
  s.module_name   = 'SwiftRegularExpression'
  s.version       = '0.2.3'
  s.summary       = '🏰 SwiftRegularExpression'

  s.swift_version = '4.2'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'SwiftRegularExpression - Swift Regular Extensions for Swift'
  s.homepage         = 'https://github.com/nerzh/swift-regular-expression'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Oleh Hudeichuk' => 'emptystamp@gmail.com' }
  s.source           = { :git => 'https://github.com/nerzh/swift-regular-expression.git', :tag => s.version.to_s }
  s.social_media_url = 'https://www.linkedin.com/in/oleh-gudeychuk-428389ab'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Sources/**/*'
  s.frameworks = 'Foundation'
end