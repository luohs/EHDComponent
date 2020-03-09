#
# Be sure to run `pod lib lint EHDComponent.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EHDComponent'
  s.version          = '1.0.1'
  s.summary          = 'A short description of EHDComponent.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/luohs/EHDComponent'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'luohs' => '18330@etransfar.com' }
  # s.source           = { :svn => 'https://10.7.12.91/repo/EHDiOS/trunk/EHDComponentRepo/EHDComponent', :tag => s.version.to_s }
  s.source           = { :git => 'http://gitlab.tf56.lo/tfic-frontend-client/ios-components-repo/common/ehdcomponent.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  # s.source_files = 'EHDComponent/Classes/**/*.{h,m,mm}'

  path = 'EHDComponent/Classes/'
  regular = '/*.{m,h}'

  s.subspec 'URLRoute' do |ss|
    ss.source_files = [path + 'Extension/Route/URLRoute' + regular]
  end

  s.subspec 'Core' do |ss|
    ss.source_files = [path + 'Core/AbsLayer/Handler' + regular,
                      path + 'Core/AbsLayer/Layer' + regular,
                      path + 'Core/Component/Manager' + regular,
                      path + 'Core/Component/Recognizer' + regular,
                      path + 'Core/Component/WorkBus' + regular,
                      path + 'Core/PlugInterface' + regular,
                      path + 'Common' + regular,
                    ]
    ss.dependency 'EHDComponent/URLRoute'
  end

  # s.resource_bundles = {
  #   'EHDComponent' => ['EHDComponent/Assets/**/*.{png,json}']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
