Pod::Spec.new do |spec|
  spec.name         = "LicenseChain"
  spec.version      = "1.0.1"
  spec.summary      = "Official macOS SDK for LicenseChain - Secure license management for macOS applications"
  spec.description  = <<-DESC
                   LicenseChain macOS SDK provides secure license management for macOS applications.
                   Features include user authentication, license validation, hardware ID protection,
                   webhook support, analytics integration, and more.
                   DESC

  spec.homepage     = "https://github.com/LicenseChain/LicenseChain-macOS-SDK"
  spec.license      = { :type => "Elastic-2.0", :file => "LICENSE" }
  spec.author       = { "LicenseChain Team" => "support@licensechain.app" }
  
  spec.platform     = :osx, "13.0"
  spec.swift_version = "5.9"
  
  spec.source       = { :git => "https://github.com/LicenseChain/LicenseChain-macOS-SDK.git", :tag => "v#{spec.version}" }
  spec.source_files = "Sources/**/*.swift"
  
  spec.dependency 'Alamofire', '~> 5.8'
  spec.dependency 'SwiftyJSON', '~> 5.0'
  
  spec.requires_arc = true
end
