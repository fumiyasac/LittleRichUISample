platform :ios, '8.0'
swift_version = '2.3'
use_frameworks!
target 'LittleRichUISample' do
  pod 'SlideMenuControllerSwift', git: 'https://github.com/dekatotoro/SlideMenuControllerSwift.git', branch: 'swift2.3'
  pod 'BubbleTransition', git: 'https://github.com/andreamazz/BubbleTransition', branch: 'swift2.3'
  pod 'LTMorphingLabel', git: 'https://github.com/lexrus/LTMorphingLabel.git', branch: 'master'
  pod 'Gecco'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '2.3'
      end
    end
  end

end
