import Cocoa
import LicenseChain

/**
 * LicenseChain macOS SDK - Advanced Features Example
 * 
 * This example demonstrates advanced features of the LicenseChain macOS SDK
 * including webhook integration, analytics, and error handling.
 */
class AdvancedFeaturesViewController: NSViewController {
    
    private var licenseClient: LicenseChainClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the LicenseChain client with advanced configuration
        initializeLicenseChain()
        
        // Demonstrate advanced functionality
        demonstrateAdvancedFeatures()
    }
    
    private func initializeLicenseChain() {
        print("🚀 LicenseChain macOS SDK - Advanced Features Example")
        print("=" + String(repeating: "=", count: 50))
        
        // Initialize the client with advanced configuration
        let config = LicenseChainConfig(
            apiKey: "your-api-key-here",
            appName: "MyAdvancedMacOSApp",
            version: "1.0.0",
            baseUrl: "https://api.licensechain.app",
            timeout: 30,
            retries: 3,
            debug: true,
            userAgent: "MyApp/1.0.0"
        )
        
        licenseClient = LicenseChainClient(config: config)
        
        print("✅ Advanced LicenseChain client initialized")
    }
    
    private func demonstrateAdvancedFeatures() {
        Task {
            do {
                // Connect to LicenseChain
                print("\n🔌 Connecting to LicenseChain...")
                try await licenseClient.connect()
                print("✅ Connected to LicenseChain successfully!")
                
                // Example 1: Webhook Integration
                print("\n🔔 Setting up webhook integration...")
                licenseClient.setWebhookHandler { event, data in
                    print("Webhook received: \(event)")
                    switch event {
                    case "license.created":
                        print("New license created: \(data["licenseKey"] ?? "")")
                    case "license.updated":
                        print("License updated: \(data["licenseKey"] ?? "")")
                    case "license.revoked":
                        print("License revoked: \(data["licenseKey"] ?? "")")
                    default:
                        break
                    }
                }
                
                // Start webhook listener
                try await licenseClient.startWebhookListener()
                print("✅ Webhook listener started!")
                
                // Example 2: Advanced Analytics
                print("\n📊 Advanced analytics tracking...")
                do {
                    try await licenseClient.trackEvent("app.advanced_features_started", properties: [
                        "feature": "webhook_integration",
                        "platform": "macos",
                        "version": "1.0.0",
                        "userAgent": "MyApp/1.0.0"
                    ])
                    print("✅ Advanced analytics tracked!")
                } catch {
                    print("❌ Failed to track analytics: \(error.localizedDescription)")
                }
                
                // Example 3: Performance Monitoring
                print("\n📈 Performance monitoring...")
                do {
                    let metrics = try await licenseClient.getPerformanceMetrics()
                    print("API Response Time: \(metrics.averageResponseTime)ms")
                    print("Success Rate: \(metrics.successRate * 100)%")
                    print("Error Count: \(metrics.errorCount)")
                    print("✅ Performance metrics retrieved!")
                } catch {
                    print("❌ Failed to get performance metrics: \(error.localizedDescription)")
                }
                
                // Example 4: Error Handling
                print("\n🛡️ Advanced error handling...")
                do {
                    let license = try await licenseClient.validateLicense("invalid-key")
                    print("License validation result: \(license.key)")
                } catch let error as InvalidLicenseError {
                    print("✅ Caught InvalidLicenseError: \(error.localizedDescription)")
                } catch let error as ExpiredLicenseError {
                    print("✅ Caught ExpiredLicenseError: \(error.localizedDescription)")
                } catch let error as NetworkError {
                    print("✅ Caught NetworkError: \(error.localizedDescription)")
                } catch {
                    print("❌ Unexpected error: \(error.localizedDescription)")
                }
                
                // Cleanup
                print("\n🧹 Cleaning up...")
                try await licenseClient.stopWebhookListener()
                try await licenseClient.logout()
                try await licenseClient.disconnect()
                print("✅ Cleanup completed!")
                
                print("\n🎉 All advanced examples completed!")
                
            } catch {
                print("❌ Error during advanced demonstration: \(error.localizedDescription)")
            }
        }
    }
}
