# LicenseChain macOS SDK

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![macOS](https://img.shields.io/badge/macOS-10.15+-blue.svg)](https://developer.apple.com/macos/)
[![Swift](https://img.shields.io/badge/Swift-5.0+-orange.svg)](https://swift.org/)
[![CocoaPods](https://img.shields.io/badge/CocoaPods-1.0+-green.svg)](https://cocoapods.org/)

Official macOS SDK for LicenseChain - Secure license management for macOS applications.

## ðŸš€ Features

- **ðŸ” Secure Authentication** - User registration, login, and session management
- **ðŸ“œ License Management** - Create, validate, update, and revoke licenses
- **ðŸ›¡ï¸ Hardware ID Validation** - Prevent license sharing and unauthorized access
- **ðŸ”” Webhook Support** - Real-time license events and notifications
- **ðŸ“Š Analytics Integration** - Track license usage and performance metrics
- **âš¡ High Performance** - Optimized for macOS runtime
- **ðŸ”„ Async Operations** - Non-blocking HTTP requests and data processing
- **ðŸ› ï¸ Easy Integration** - Simple API with comprehensive documentation

## ðŸ“¦ Installation

### Method 1: CocoaPods (Recommended)

Add to your `Podfile`:

```ruby
pod 'LicenseChain', '~> 1.0'
```

Then run:

```bash
pod install
```

### Method 2: Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/LicenseChain/LicenseChain-macOS-SDK.git", from: "1.0.0")
]
```

### Method 3: Manual Installation

1. Download the latest release from [GitHub Releases](https://github.com/LicenseChain/LicenseChain-macOS-SDK/releases)
2. Add the framework to your Xcode project
3. Link the framework in your target's "Frameworks and Libraries"

## ðŸš€ Quick Start

### Basic Setup

```swift
import LicenseChain

class AppDelegate: NSObject, NSApplicationDelegate {
    private var licenseClient: LicenseChainClient!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Initialize the client
        let config = LicenseChainConfig(
            apiKey: "your-api-key",
            appName: "your-app-name",
            version: "1.0.0"
        )
        
        licenseClient = LicenseChainClient(config: config)
        
        // Connect to LicenseChain
        Task {
            do {
                try await licenseClient.connect()
                print("Connected to LicenseChain successfully!")
            } catch {
                print("Failed to connect: \(error.localizedDescription)")
            }
        }
    }
}
```

### User Authentication

```swift
// Register a new user
Task {
    do {
        let user = try await licenseClient.register(
            username: "username",
            password: "password",
            email: "email@example.com"
        )
        print("User registered successfully! ID: \(user.id)")
    } catch {
        print("Registration failed: \(error.localizedDescription)")
    }
}

// Login existing user
Task {
    do {
        let user = try await licenseClient.login(
            username: "username",
            password: "password"
        )
        print("User logged in successfully! Session ID: \(user.sessionId)")
    } catch {
        print("Login failed: \(error.localizedDescription)")
    }
}
```

### License Management

```swift
// Validate a license
Task {
    do {
        let license = try await licenseClient.validateLicense("LICENSE-KEY-HERE")
        print("License is valid!")
        print("License Key: \(license.key)")
        print("Status: \(license.status)")
        print("Expires: \(license.expires)")
        print("Features: \(license.features.joined(separator: ", "))")
        print("User: \(license.user)")
    } catch {
        print("License validation failed: \(error.localizedDescription)")
    }
}

// Get user's licenses
Task {
    do {
        let licenses = try await licenseClient.getUserLicenses()
        print("Found \(licenses.count) licenses:")
        for (index, license) in licenses.enumerated() {
            print("  \(index + 1). \(license.key) - \(license.status) (Expires: \(license.expires))")
        }
    } catch {
        print("Failed to get licenses: \(error.localizedDescription)")
    }
}
```

### Hardware ID Validation

```swift
// Get hardware ID (automatically generated)
let hardwareId = licenseClient.getHardwareId()
print("Hardware ID: \(hardwareId)")

// Validate hardware ID with license
Task {
    do {
        let isValid = try await licenseClient.validateHardwareId(
            licenseKey: "LICENSE-KEY-HERE",
            hardwareId: hardwareId
        )
        if isValid {
            print("Hardware ID is valid for this license!")
        } else {
            print("Hardware ID is not valid for this license.")
        }
    } catch {
        print("Hardware ID validation failed: \(error.localizedDescription)")
    }
}
```

### Webhook Integration

```swift
// Set up webhook handler
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
Task {
    do {
        try await licenseClient.startWebhookListener()
        print("Webhook listener started successfully!")
    } catch {
        print("Failed to start webhook listener: \(error.localizedDescription)")
    }
}
```

## ðŸ“š API Reference

### LicenseChainClient

#### Constructor

```swift
let config = LicenseChainConfig(
    apiKey: "your-api-key",
    appName: "your-app-name",
    version: "1.0.0",
    baseUrl: "https://api.licensechain.app" // Optional
)

let client = LicenseChainClient(config: config)
```

#### Methods

##### Connection Management

```swift
// Connect to LicenseChain
func connect() async throws

// Disconnect from LicenseChain
func disconnect() async throws

// Check connection status
var isConnected: Bool { get }
```

##### User Authentication

```swift
// Register a new user
func register(username: String, password: String, email: String) async throws -> User

// Login existing user
func login(username: String, password: String) async throws -> User

// Logout current user
func logout() async throws

// Get current user info
func getCurrentUser() async throws -> User
```

##### License Management

```swift
// Validate a license
func validateLicense(_ licenseKey: String) async throws -> License

// Get user's licenses
func getUserLicenses() async throws -> [License]

// Create a new license
func createLicense(userId: String, features: [String], expires: String) async throws -> License

// Update a license
func updateLicense(_ licenseKey: String, updates: [String: Any]) async throws -> License

// Revoke a license
func revokeLicense(_ licenseKey: String) async throws

// Extend a license
func extendLicense(_ licenseKey: String, days: Int) async throws -> License
```

##### Hardware ID Management

```swift
// Get hardware ID
func getHardwareId() -> String

// Validate hardware ID
func validateHardwareId(licenseKey: String, hardwareId: String) async throws -> Bool

// Bind hardware ID to license
func bindHardwareId(licenseKey: String, hardwareId: String) async throws
```

##### Webhook Management

```swift
// Set webhook handler
func setWebhookHandler(_ handler: @escaping (String, [String: String]) -> Void)

// Start webhook listener
func startWebhookListener() async throws

// Stop webhook listener
func stopWebhookListener() async throws
```

##### Analytics

```swift
// Track event
func trackEvent(_ eventName: String, properties: [String: Any]) async throws

// Get analytics data
func getAnalytics(timeRange: String) async throws -> Analytics
```

## ðŸ”§ Configuration

### Info.plist

Add required permissions to your `Info.plist`:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

### App Transport Security

For production, configure ATS properly:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSExceptionDomains</key>
    <dict>
        <key>api.licensechain.app</key>
        <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <false/>
            <key>NSExceptionMinimumTLSVersion</key>
            <string>TLSv1.2</string>
        </dict>
    </dict>
</dict>
```

### Environment Variables

Set these in your build settings or through your build process:

```swift
// In your app configuration
let apiKey = Bundle.main.object(forInfoDictionaryKey: "LICENSECHAIN_API_KEY") as? String ?? ""
let appName = Bundle.main.object(forInfoDictionaryKey: "LICENSECHAIN_APP_NAME") as? String ?? ""
let version = Bundle.main.object(forInfoDictionaryKey: "LICENSECHAIN_APP_VERSION") as? String ?? ""
```

### Advanced Configuration

```swift
let config = LicenseChainConfig(
    apiKey: "your-api-key",
    appName: "your-app-name",
    version: "1.0.0",
    baseUrl: "https://api.licensechain.app",
    timeout: 30,        // Request timeout in seconds
    retries: 3,         // Number of retry attempts
    debug: false,       // Enable debug logging
    userAgent: "MyApp/1.0.0"  // Custom user agent
)
```

## ðŸ›¡ï¸ Security Features

### Hardware ID Protection

The SDK automatically generates and manages hardware IDs to prevent license sharing:

```swift
// Hardware ID is automatically generated and stored
let hardwareId = licenseClient.getHardwareId()

// Validate against license
let isValid = try await licenseClient.validateHardwareId(licenseKey: licenseKey, hardwareId: hardwareId)
```

### Secure Communication

- All API requests use HTTPS
- API keys are securely stored and transmitted
- Session tokens are automatically managed
- Webhook signatures are verified

### License Validation

- Real-time license validation
- Hardware ID binding
- Expiration checking
- Feature-based access control

## ðŸ“Š Analytics and Monitoring

### Event Tracking

```swift
// Track custom events
Task {
    do {
        try await licenseClient.trackEvent("app.started", properties: [
            "level": 1,
            "playerCount": 10
        ])
    } catch {
        print("Failed to track event: \(error.localizedDescription)")
    }
}

// Track license events
Task {
    do {
        try await licenseClient.trackEvent("license.validated", properties: [
            "licenseKey": "LICENSE-KEY",
            "features": "premium,unlimited"
        ])
    } catch {
        print("Failed to track event: \(error.localizedDescription)")
    }
}
```

### Performance Monitoring

```swift
// Get performance metrics
Task {
    do {
        let metrics = try await licenseClient.getPerformanceMetrics()
        print("API Response Time: \(metrics.averageResponseTime)ms")
        print("Success Rate: \(metrics.successRate * 100)%")
        print("Error Count: \(metrics.errorCount)")
    } catch {
        print("Failed to get metrics: \(error.localizedDescription)")
    }
}
```

## ðŸ”„ Error Handling

### Custom Error Types

```swift
do {
    let license = try await licenseClient.validateLicense("invalid-key")
} catch let error as InvalidLicenseError {
    print("License key is invalid")
} catch let error as ExpiredLicenseError {
    print("License has expired")
} catch let error as NetworkError {
    print("Network connection failed: \(error.localizedDescription)")
} catch let error as LicenseChainError {
    print("LicenseChain error: \(error.localizedDescription)")
} catch {
    print("Unknown error: \(error.localizedDescription)")
}
```

### Retry Logic

```swift
// Automatic retry for network errors
let config = LicenseChainConfig(
    apiKey: "your-api-key",
    appName: "your-app-name",
    version: "1.0.0",
    retries: 3,        // Retry up to 3 times
    timeout: 30        // Wait 30 seconds for each request
)
```

## ðŸ§ª Testing

### Unit Tests

```swift
// Example test
func testValidateLicense() async throws {
    let client = LicenseChainClient(config: testConfig)
    let license = try await client.validateLicense("test-license-key")
    XCTAssertTrue(license.isValid)
}
```

### Integration Tests

```swift
// Test with real API
func testIntegration() async throws {
    let client = LicenseChainClient(config: realConfig)
    try await client.connect()
    let licenses = try await client.getUserLicenses()
    XCTAssertNotNil(licenses)
}
```

## ðŸ“ Examples

See the `Examples/` directory for complete examples:

- `BasicUsageViewController.swift` - Basic SDK usage
- `AdvancedFeaturesViewController.swift` - Advanced features and configuration
- `WebhookIntegrationViewController.swift` - Webhook handling

## ðŸ¤ Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Setup

1. Clone the repository
2. Install Xcode 13 or later
3. Install macOS 10.15 or later
4. Build: `xcodebuild -scheme LicenseChain build`
5. Test: `xcodebuild -scheme LicenseChain test`

## ðŸ“„ License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ðŸ†˜ Support

- **Documentation**: [https://docs.licensechain.app/macos](https://docs.licensechain.app/macos)
- **Issues**: [GitHub Issues](https://github.com/LicenseChain/LicenseChain-macOS-SDK/issues)
- **Discord**: [LicenseChain Discord](https://discord.gg/licensechain)
- **Email**: support@licensechain.app

## ðŸ”— Related Projects

- [LicenseChain iOS SDK](https://github.com/LicenseChain/LicenseChain-iOS-SDK)
- [LicenseChain Android SDK](https://github.com/LicenseChain/LicenseChain-Android-SDK)
- [LicenseChain Customer Panel](https://github.com/LicenseChain/LicenseChain-Customer-Panel)

---

**Made with â¤ï¸ for the macOS community**


## API Endpoints

All endpoints automatically use the /v1 prefix when connecting to https://api.licensechain.app.

### Base URL
- **Production**: https://api.licensechain.app/v1\n- **Development**: https://api.licensechain.app/v1\n\n### Available Endpoints\n\n| Method | Endpoint | Description |\n|--------|----------|-------------|\n| GET | /v1/health | Health check |\n| POST | /v1/auth/login | User login |\n| POST | /v1/auth/register | User registration |\n| GET | /v1/apps | List applications |\n| POST | /v1/apps | Create application |\n| GET | /v1/licenses | List licenses |\n| POST | /v1/licenses/verify | Verify license |\n| GET | /v1/webhooks | List webhooks |\n| POST | /v1/webhooks | Create webhook |\n| GET | /v1/analytics | Get analytics |\n\n**Note**: The SDK automatically prepends /v1 to all endpoints, so you only need to specify the path (e.g., /auth/login instead of /v1/auth/login).

