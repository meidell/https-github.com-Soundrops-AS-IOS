source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '16.0'
use_frameworks!

target 'Soundrops' do
    pod 'Alamofire', '~> 5.0'
    pod 'AlamofireImage', '~> 4.0'
    pod 'PushNotifications', '~> 1.2.0'
    pod 'SwiftyJSON'
    pod 'GoogleMaps'
    pod 'GooglePlaces'
    pod 'GooglePlacePicker'
    pod 'GoogleSignIn', '~> 5.0'
    pod 'Firebase/Core'
    pod 'Firebase/Auth'
    pod 'ReachabilitySwift'
    pod 'KeychainSwift'
end

target 'PusherNotifications' do
    pod 'Alamofire', '~> 5.0'
    pod 'AlamofireImage', '~> 4.0'
    pod 'KeychainSwift'
end

deployment_target = '16.0'

post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              
              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
          xcconfig_path = config.base_configuration_reference.real_path
          xcconfig = File.read(xcconfig_path)
          xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
          File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
          end
      end
  end

