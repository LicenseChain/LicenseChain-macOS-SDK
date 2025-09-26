import Cocoa
import LicenseChain

/**
 * LicenseChain macOS SDK - Basic Usage Example
 * 
 * This example demonstrates basic usage of the LicenseChain macOS SDK
 * including initialization, user authentication, and license management.
 */
class BasicUsageViewController: NSViewController {
    
    private var licenseClient: LicenseChainClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the LicenseChain client
        initializeLicenseChain()
        
        // Demonstrate basic functionality
        demonstrateBasicUsage()
    }
    
    private func initializeLicenseChain() {
        print("🚀 LicenseChain macOS SDK - Basic Usage Example")
        print("=" + String(repeating: "=", count: 50))
        
        // Initialize the client
        let config = LicenseChainConfig(
            apiKey: "your-api-key-here",
            appName: "MyMacOSApp",
            version: "1.0.0",
            debug: true
        )
        
        licenseClient = LicenseChainClient(config: config)
        
        print("✅ LicenseChain client initialized")
    }
    
    private func demonstrateBasicUsage() {
        Task {
            do {
                // Connect to LicenseChain
                print("\n🔌 Connecting to LicenseChain...")
                try await licenseClient.connect()
                print("✅ Connected to LicenseChain successfully!")
                
                // Example 1: User Registration
                print("\n📝 Registering new user...")
                do {
                    let user = try await licenseClient.register(
                        username: "testuser",
                        password: "password123",
                        email: "test@example.com"
                    )
                    print("✅ User registered successfully!")
                    print("User ID: \(user.id)")
                } catch {
                    print("❌ Registration failed: \(error.localizedDescription)")
                }
                
                // Example 2: User Login
                print("\n🔐 Logging in user...")
                do {
                    let user = try await licenseClient.login(
                        username: "testuser",
                        password: "password123"
                    )
                    print("✅ User logged in successfully!")
                    print("Session ID: \(user.sessionId)")
                } catch {
                    print("❌ Login failed: \(error.localizedDescription)")
                }
                
                // Example 3: License Validation
                print("\n🔍 Validating license...")
                do {
                    let license = try await licenseClient.validateLicense("LICENSE-KEY-HERE")
                    print("✅ License is valid!")
                    print("License Key: \(license.key)")
                    print("Status: \(license.status)")
                    print("Expires: \(license.expires)")
                    print("Features: \(license.features.joined(separator: ", "))")
                    print("User: \(license.user)")
                } catch {
                    print("❌ License validation failed: \(error.localizedDescription)")
                }
                
                // Example 4: Hardware ID
                print("\n🖥️ Getting hardware ID...")
                let hardwareId = licenseClient.getHardwareId()
                print("Hardware ID: \(hardwareId)")
                
                // Example 5: Analytics
                print("\n📊 Tracking analytics...")
                do {
                    try await licenseClient.trackEvent("app.started", properties: [
                        "level": 1,
                        "playerCount": 10
                    ])
                    print("✅ Event tracked successfully!")
                } catch {
                    print("❌ Failed to track event: \(error.localizedDescription)")
                }
                
                // Cleanup
                print("\n🧹 Cleaning up...")
                try await licenseClient.logout()
                try await licenseClient.disconnect()
                print("✅ Cleanup completed!")
                
                print("\n🎉 All examples completed!")
                
            } catch {
                print("❌ Error during demonstration: \(error.localizedDescription)")
            }
        }
    }
}
