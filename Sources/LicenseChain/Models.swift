import Foundation

// MARK: - License Models

public struct License: Codable {
    public let id: String
    public let userId: String
    public let productId: String
    public let licenseKey: String
    public let status: String
    public let createdAt: String
    public let updatedAt: String
    public let expiresAt: String?
    public let metadata: [String: Any]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case productId = "product_id"
        case licenseKey = "license_key"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case expiresAt = "expires_at"
        case metadata
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        userId = try container.decode(String.self, forKey: .userId)
        productId = try container.decode(String.self, forKey: .productId)
        licenseKey = try container.decode(String.self, forKey: .licenseKey)
        status = try container.decode(String.self, forKey: .status)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)
        expiresAt = try container.decodeIfPresent(String.self, forKey: .expiresAt)
        metadata = try container.decodeIfPresent([String: Any].self, forKey: .metadata)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(productId, forKey: .productId)
        try container.encode(licenseKey, forKey: .licenseKey)
        try container.encode(status, forKey: .status)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encodeIfPresent(expiresAt, forKey: .expiresAt)
        try container.encodeIfPresent(metadata, forKey: .metadata)
    }
}

public struct CreateLicenseRequest: Codable {
    public let userId: String
    public let productId: String
    public let metadata: [String: Any]?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case productId = "product_id"
        case metadata
    }
    
    public init(userId: String, productId: String, metadata: [String: Any]? = nil) {
        self.userId = userId
        self.productId = productId
        self.metadata = metadata
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userId, forKey: .userId)
        try container.encode(productId, forKey: .productId)
        try container.encodeIfPresent(metadata, forKey: .metadata)
    }
}

public struct LicenseListResponse: Codable {
    public let data: [License]
    public let total: Int
    public let page: Int
    public let limit: Int
}

public struct LicenseStats: Codable {
    public let total: Int
    public let active: Int
    public let expired: Int
    public let revoked: Int
    public let revenue: Double
    
    public init() {
        self.total = 0
        self.active = 0
        self.expired = 0
        self.revoked = 0
        self.revenue = 0.0
    }
}

// MARK: - User Models

public struct User: Codable {
    public let id: String
    public let email: String
    public let name: String
    public let createdAt: String
    public let updatedAt: String
    public let metadata: [String: Any]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case metadata
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        email = try container.decode(String.self, forKey: .email)
        name = try container.decode(String.self, forKey: .name)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)
        metadata = try container.decodeIfPresent([String: Any].self, forKey: .metadata)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(email, forKey: .email)
        try container.encode(name, forKey: .name)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encodeIfPresent(metadata, forKey: .metadata)
    }
}

public struct CreateUserRequest: Codable {
    public let email: String
    public let name: String
    public let metadata: [String: Any]?
    
    public init(email: String, name: String, metadata: [String: Any]? = nil) {
        self.email = email
        self.name = name
        self.metadata = metadata
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(email, forKey: .email)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(metadata, forKey: .metadata)
    }
}

public struct UserListResponse: Codable {
    public let data: [User]
    public let total: Int
    public let page: Int
    public let limit: Int
}

public struct UserStats: Codable {
    public let total: Int
    public let active: Int
    public let inactive: Int
    
    public init() {
        self.total = 0
        self.active = 0
        self.inactive = 0
    }
}

// MARK: - Product Models

public struct Product: Codable {
    public let id: String
    public let name: String
    public let description: String?
    public let price: Double
    public let currency: String
    public let createdAt: String
    public let updatedAt: String
    public let metadata: [String: Any]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case price
        case currency
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case metadata
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        price = try container.decode(Double.self, forKey: .price)
        currency = try container.decode(String.self, forKey: .currency)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)
        metadata = try container.decodeIfPresent([String: Any].self, forKey: .metadata)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encode(price, forKey: .price)
        try container.encode(currency, forKey: .currency)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encodeIfPresent(metadata, forKey: .metadata)
    }
}

public struct CreateProductRequest: Codable {
    public let name: String
    public let description: String?
    public let price: Double
    public let currency: String
    public let metadata: [String: Any]?
    
    public init(name: String, description: String?, price: Double, currency: String, metadata: [String: Any]? = nil) {
        self.name = name
        self.description = description
        self.price = price
        self.currency = currency
        self.metadata = metadata
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encode(price, forKey: .price)
        try container.encode(currency, forKey: .currency)
        try container.encodeIfPresent(metadata, forKey: .metadata)
    }
}

public struct ProductListResponse: Codable {
    public let data: [Product]
    public let total: Int
    public let page: Int
    public let limit: Int
}

public struct ProductStats: Codable {
    public let total: Int
    public let active: Int
    public let revenue: Double
    
    public init() {
        self.total = 0
        self.active = 0
        self.revenue = 0.0
    }
}

// MARK: - Webhook Models

public struct Webhook: Codable {
    public let id: String
    public let url: String
    public let events: [String]
    public let secret: String?
    public let createdAt: String
    public let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case events
        case secret
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

public struct CreateWebhookRequest: Codable {
    public let url: String
    public let events: [String]
    public let secret: String?
    
    public init(url: String, events: [String], secret: String? = nil) {
        self.url = url
        self.events = events
        self.secret = secret
    }
}
