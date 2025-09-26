# Uncomment the next line to define a global platform for your project
platform :osx, '10.15'

target 'LicenseChain' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for LicenseChain
  pod 'Alamofire', '~> 5.8'
  pod 'SwiftyJSON', '~> 5.0'

  target 'LicenseChainTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Quick', '~> 7.0'
    pod 'Nimble', '~> 12.0'
  end

  target 'LicenseChainUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.15'
    end
  end
end
