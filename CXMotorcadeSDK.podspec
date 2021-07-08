#
# Be sure to run `pod lib lint CXMotorcadeSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do | s |
    s.name             = 'CXMotorcadeSDK'
    s.version          = '1.0'
    s.summary          = '蘑菇小队'
    
    # This description is used to generate tags and improve search results.
    # * Think: What does it do? Why did you write it? What is the focus?
    # * Try to keep it short, snappy and to the point.
    # * Write the description between the DESC delimiters below.
    # * Finally, don't worry about the indent, CocoaPods strips it!
    
    s.description      = '蘑菇小队'
    s.homepage         = 'https://github.com/ishaolin/CXMotorcadeSDK'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'wshaolin' => 'ishaolin@163.com' }
    s.source           = { :git => 'https://github.com/ishaolin/CXMotorcadeSDK.git', :tag => s.version.to_s }
    
    s.ios.deployment_target = '9.0'
    
    s.resource_bundles = {
        'CXMotorcadeSDK' => ['CXMotorcadeSDK/Assets/*']
    }
    
    s.source_files = 'CXMotorcadeSDK/Classes/**/*'
    
    s.dependency 'CXNetSDK'
    s.dependency 'CXMapKit'
    s.dependency 'CXVoiceSDK'
    s.dependency 'CXIMUI'
    s.dependency 'CXSettingKit'
    s.dependency 'CXSocketSDK'
    s.dependency 'CXShareSDK'
    s.dependency 'CXAntiSDK'
end
