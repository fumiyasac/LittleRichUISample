platform :ios, '8.0'
swift_version = '3.0'
use_frameworks!
target 'LittleRichUISample' do
  pod 'SlideMenuControllerSwift', git: 'https://github.com/dekatotoro/SlideMenuControllerSwift.git', branch: 'master'
  pod 'BubbleTransition', git: 'https://github.com/andreamazz/BubbleTransition', branch: 'master'
  pod 'LTMorphingLabel', git: 'https://github.com/lexrus/LTMorphingLabel', branch: 'swift3'
  pod 'Gecco', git: 'https://github.com/yukiasai/Gecco', branch: 'master'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.0'
      end
    end
  end
end
