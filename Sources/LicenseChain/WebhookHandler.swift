import Foundation

public class WebhookHandler {
    private let secret: String
    private let tolerance: TimeInterval
    
    public init(secret: String, tolerance: TimeInterval = 300) {
        self.secret = secret
        self.tolerance = tolerance
    }
    
    public func verifySignature(payload: String, signature: String) -> Bool {
        return LicenseChainUtils.verifyWebhookSignature(payload: payload, signature: signature, secret: secret)
    }
    
    public func verifyTimestamp(_ timestamp: String) throws {
        guard let webhookTime = LicenseChainUtils.parseTimestamp(timestamp) else {
            throw LicenseChainError.validationError("Invalid timestamp format")
        }
        
        let currentTime = LicenseChainUtils.getCurrentTimestamp()
        let timeDiff = abs(currentTime - webhookTime)
        
        if timeDiff > tolerance {
            throw LicenseChainError.validationError("Webhook timestamp too old: \(timeDiff) seconds")
        }
    }
    
    public func verifyWebhook(payload: String, signature: String, timestamp: String) throws {
        try verifyTimestamp(timestamp)
        
        if !verifySignature(payload: payload, signature: signature) {
            throw LicenseChainError.authenticationError("Invalid webhook signature")
        }
    }
    
    public func processEvent(_ eventData: [String: Any]) throws {
        guard let payload = LicenseChainUtils.jsonSerialize(eventData["data"] as? [String: Any] ?? [:]) else {
            throw LicenseChainError.validationError("Invalid event data")
        }
        
        guard let signature = eventData["signature"] as? String else {
            throw LicenseChainError.validationError("Missing signature")
        }
        
        guard let timestamp = eventData["timestamp"] as? String else {
            throw LicenseChainError.validationError("Missing timestamp")
        }
        
        try verifyWebhook(payload: payload, signature: signature, timestamp: timestamp)
        
        let eventType = eventData["type"] as? String ?? ""
        
        switch eventType {
        case "license.created":
            try handleLicenseCreated(eventData)
        case "license.updated":
            try handleLicenseUpdated(eventData)
        case "license.revoked":
            try handleLicenseRevoked(eventData)
        case "license.expired":
            try handleLicenseExpired(eventData)
        case "user.created":
            try handleUserCreated(eventData)
        case "user.updated":
            try handleUserUpdated(eventData)
        case "user.deleted":
            try handleUserDeleted(eventData)
        case "product.created":
            try handleProductCreated(eventData)
        case "product.updated":
            try handleProductUpdated(eventData)
        case "product.deleted":
            try handleProductDeleted(eventData)
        case "payment.completed":
            try handlePaymentCompleted(eventData)
        case "payment.failed":
            try handlePaymentFailed(eventData)
        case "payment.refunded":
            try handlePaymentRefunded(eventData)
        default:
            print("Unknown webhook event type: \(eventType)")
        }
    }
    
    // MARK: - Event Handlers
    
    private func handleLicenseCreated(_ eventData: [String: Any]) throws {
        let id = eventData["id"] as? String ?? "unknown"
        print("License created: \(id)")
        // Add custom logic for license created event
    }
    
    private func handleLicenseUpdated(_ eventData: [String: Any]) throws {
        let id = eventData["id"] as? String ?? "unknown"
        print("License updated: \(id)")
        // Add custom logic for license updated event
    }
    
    private func handleLicenseRevoked(_ eventData: [String: Any]) throws {
        let id = eventData["id"] as? String ?? "unknown"
        print("License revoked: \(id)")
        // Add custom logic for license revoked event
    }
    
    private func handleLicenseExpired(_ eventData: [String: Any]) throws {
        let id = eventData["id"] as? String ?? "unknown"
        print("License expired: \(id)")
        // Add custom logic for license expired event
    }
    
    private func handleUserCreated(_ eventData: [String: Any]) throws {
        let id = eventData["id"] as? String ?? "unknown"
        print("User created: \(id)")
        // Add custom logic for user created event
    }
    
    private func handleUserUpdated(_ eventData: [String: Any]) throws {
        let id = eventData["id"] as? String ?? "unknown"
        print("User updated: \(id)")
        // Add custom logic for user updated event
    }
    
    private func handleUserDeleted(_ eventData: [String: Any]) throws {
        let id = eventData["id"] as? String ?? "unknown"
        print("User deleted: \(id)")
        // Add custom logic for user deleted event
    }
    
    private func handleProductCreated(_ eventData: [String: Any]) throws {
        let id = eventData["id"] as? String ?? "unknown"
        print("Product created: \(id)")
        // Add custom logic for product created event
    }
    
    private func handleProductUpdated(_ eventData: [String: Any]) throws {
        let id = eventData["id"] as? String ?? "unknown"
        print("Product updated: \(id)")
        // Add custom logic for product updated event
    }
    
    private func handleProductDeleted(_ eventData: [String: Any]) throws {
        let id = eventData["id"] as? String ?? "unknown"
        print("Product deleted: \(id)")
        // Add custom logic for product deleted event
    }
    
    private func handlePaymentCompleted(_ eventData: [String: Any]) throws {
        let id = eventData["id"] as? String ?? "unknown"
        print("Payment completed: \(id)")
        // Add custom logic for payment completed event
    }
    
    private func handlePaymentFailed(_ eventData: [String: Any]) throws {
        let id = eventData["id"] as? String ?? "unknown"
        print("Payment failed: \(id)")
        // Add custom logic for payment failed event
    }
    
    private func handlePaymentRefunded(_ eventData: [String: Any]) throws {
        let id = eventData["id"] as? String ?? "unknown"
        print("Payment refunded: \(id)")
        // Add custom logic for payment refunded event
    }
}

public struct WebhookEvents {
    public static let licenseCreated = "license.created"
    public static let licenseUpdated = "license.updated"
    public static let licenseRevoked = "license.revoked"
    public static let licenseExpired = "license.expired"
    public static let userCreated = "user.created"
    public static let userUpdated = "user.updated"
    public static let userDeleted = "user.deleted"
    public static let productCreated = "product.created"
    public static let productUpdated = "product.updated"
    public static let productDeleted = "product.deleted"
    public static let paymentCompleted = "payment.completed"
    public static let paymentFailed = "payment.failed"
    public static let paymentRefunded = "payment.refunded"
}
