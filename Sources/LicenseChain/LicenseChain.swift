import Foundation

public class LicenseChain {
    private let apiKey: String
    private let baseURL: String
    private let timeout: TimeInterval
    private let retries: Int
    
    public init(apiKey: String, baseURL: String = "https://api.licensechain.app", timeout: TimeInterval = 30.0, retries: Int = 3) {
        self.apiKey = apiKey
        self.baseURL = baseURL
        self.timeout = timeout
        self.retries = retries
    }
    
    public static func create(apiKey: String, baseURL: String? = nil) -> LicenseChain {
        return LicenseChain(apiKey: apiKey, baseURL: baseURL ?? "https://api.licensechain.app")
    }
    
    public static func fromEnvironment() -> LicenseChain {
        let apiKey = ProcessInfo.processInfo.environment["LICENSECHAIN_API_KEY"] ?? ""
        let baseURL = ProcessInfo.processInfo.environment["LICENSECHAIN_BASE_URL"] ?? "https://api.licensechain.app"
        return LicenseChain(apiKey: apiKey, baseURL: baseURL)
    }
    
    // MARK: - License Management
    
    public func createLicense(userId: String, productId: String, metadata: [String: Any]? = nil) async throws -> License {
        let request = CreateLicenseRequest(userId: userId, productId: productId, metadata: metadata)
        return try await makeRequest(method: "POST", endpoint: "/licenses", body: request)
    }
    
    public func getLicense(licenseId: String) async throws -> License {
        return try await makeRequest(method: "GET", endpoint: "/licenses/\(licenseId)")
    }
    
    public func updateLicense(licenseId: String, updates: [String: Any]) async throws -> License {
        return try await makeRequest(method: "PUT", endpoint: "/licenses/\(licenseId)", body: updates)
    }
    
    public func revokeLicense(licenseId: String) async throws {
        try await makeRequest(method: "DELETE", endpoint: "/licenses/\(licenseId)")
    }
    
    public func validateLicense(licenseKey: String) async throws -> Bool {
        // Use /licenses/verify endpoint with 'key' parameter to match API
        let request = ["key": licenseKey]
        let response: [String: Bool] = try await makeRequest(method: "POST", endpoint: "/licenses/verify", body: request)
        return response["valid"] ?? false
    }
    
    public func listUserLicenses(userId: String, page: Int = 1, limit: Int = 10) async throws -> LicenseListResponse {
        let params = ["user_id": userId, "page": page, "limit": limit]
        return try await makeRequest(method: "GET", endpoint: "/licenses", queryParams: params)
    }
    
    public func getLicenseStats() async throws -> LicenseStats {
        let response: [String: LicenseStats] = try await makeRequest(method: "GET", endpoint: "/licenses/stats")
        return response["data"] ?? LicenseStats()
    }
    
    // MARK: - User Management
    
    public func createUser(email: String, name: String, metadata: [String: Any]? = nil) async throws -> User {
        let request = CreateUserRequest(email: email, name: name, metadata: metadata)
        return try await makeRequest(method: "POST", endpoint: "/users", body: request)
    }
    
    public func getUser(userId: String) async throws -> User {
        return try await makeRequest(method: "GET", endpoint: "/users/\(userId)")
    }
    
    public func updateUser(userId: String, updates: [String: Any]) async throws -> User {
        return try await makeRequest(method: "PUT", endpoint: "/users/\(userId)", body: updates)
    }
    
    public func deleteUser(userId: String) async throws {
        try await makeRequest(method: "DELETE", endpoint: "/users/\(userId)")
    }
    
    public func listUsers(page: Int = 1, limit: Int = 10) async throws -> UserListResponse {
        let params = ["page": page, "limit": limit]
        return try await makeRequest(method: "GET", endpoint: "/users", queryParams: params)
    }
    
    public func getUserStats() async throws -> UserStats {
        let response: [String: UserStats] = try await makeRequest(method: "GET", endpoint: "/users/stats")
        return response["data"] ?? UserStats()
    }
    
    // MARK: - Product Management
    
    public func createProduct(name: String, description: String?, price: Double, currency: String, metadata: [String: Any]? = nil) async throws -> Product {
        let request = CreateProductRequest(name: name, description: description, price: price, currency: currency, metadata: metadata)
        return try await makeRequest(method: "POST", endpoint: "/products", body: request)
    }
    
    public func getProduct(productId: String) async throws -> Product {
        return try await makeRequest(method: "GET", endpoint: "/products/\(productId)")
    }
    
    public func updateProduct(productId: String, updates: [String: Any]) async throws -> Product {
        return try await makeRequest(method: "PUT", endpoint: "/products/\(productId)", body: updates)
    }
    
    public func deleteProduct(productId: String) async throws {
        try await makeRequest(method: "DELETE", endpoint: "/products/\(productId)")
    }
    
    public func listProducts(page: Int = 1, limit: Int = 10) async throws -> ProductListResponse {
        let params = ["page": page, "limit": limit]
        return try await makeRequest(method: "GET", endpoint: "/products", queryParams: params)
    }
    
    public func getProductStats() async throws -> ProductStats {
        let response: [String: ProductStats] = try await makeRequest(method: "GET", endpoint: "/products/stats")
        return response["data"] ?? ProductStats()
    }
    
    // MARK: - Webhook Management
    
    public func createWebhook(url: String, events: [String], secret: String? = nil) async throws -> Webhook {
        let request = CreateWebhookRequest(url: url, events: events, secret: secret)
        return try await makeRequest(method: "POST", endpoint: "/webhooks", body: request)
    }
    
    public func getWebhook(webhookId: String) async throws -> Webhook {
        return try await makeRequest(method: "GET", endpoint: "/webhooks/\(webhookId)")
    }
    
    public func updateWebhook(webhookId: String, updates: [String: Any]) async throws -> Webhook {
        return try await makeRequest(method: "PUT", endpoint: "/webhooks/\(webhookId)", body: updates)
    }
    
    public func deleteWebhook(webhookId: String) async throws {
        try await makeRequest(method: "DELETE", endpoint: "/webhooks/\(webhookId)")
    }
    
    public func listWebhooks() async throws -> [Webhook] {
        let response: [String: [Webhook]] = try await makeRequest(method: "GET", endpoint: "/webhooks")
        return response["data"] ?? []
    }
    
    // MARK: - Health Check
    
    public func ping() async throws -> [String: Any] {
        return try await makeRequest(method: "GET", endpoint: "/ping")
    }
    
    public func health() async throws -> [String: Any] {
        return try await makeRequest(method: "GET", endpoint: "/health")
    }
    
    // MARK: - Private Methods
    
    private func makeRequest<T: Codable>(method: String, endpoint: String, body: Any? = nil, queryParams: [String: Any]? = nil) async throws -> T {
        var urlComponents = URLComponents(string: baseURL + endpoint)
        
        if let queryParams = queryParams {
            urlComponents?.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: String(describing: $0.value)) }
        }
        
        guard let url = urlComponents?.url else {
            throw LicenseChainError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("1.0", forHTTPHeaderField: "X-API-Version")
        request.setValue("macos-sdk", forHTTPHeaderField: "X-Platform")
        request.setValue("LicenseChain-macOS-SDK/1.0.0", forHTTPHeaderField: "User-Agent")
        request.timeoutInterval = timeout
        
        if let body = body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }
        
        return try await performRequest(request)
    }
    
    private func performRequest<T: Codable>(_ request: URLRequest) async throws -> T {
        var lastError: Error?
        
        for attempt in 0..<retries {
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw LicenseChainError.invalidResponse
                }
                
                if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {
                    if data.isEmpty {
                        return try JSONDecoder().decode(T.self, from: "{}".data(using: .utf8)!)
                    }
                    return try JSONDecoder().decode(T.self, from: data)
                } else {
                    let errorMessage = try? JSONDecoder().decode([String: String].self, from: data)["error"] ?? "Unknown error"
                    throw LicenseChainError.httpError(statusCode: httpResponse.statusCode, message: errorMessage ?? "Unknown error")
                }
            } catch {
                lastError = error
                if attempt < retries - 1 {
                    try await Task.sleep(nanoseconds: UInt64(pow(2.0, Double(attempt)) * 1_000_000_000))
                }
            }
        }
        
        throw lastError ?? LicenseChainError.unknown
    }
}
