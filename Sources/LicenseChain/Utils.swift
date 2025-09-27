import Foundation
import CryptoKit

public class LicenseChainUtils {
    
    // MARK: - Validation
    
    public static func validateEmail(_ email: String) -> Bool {
        let emailRegex = "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    public static func validateLicenseKey(_ licenseKey: String) -> Bool {
        return licenseKey.count == 32 && licenseKey.allSatisfy { $0.isLetter || $0.isNumber }
    }
    
    public static func validateUUID(_ uuid: String) -> Bool {
        let uuidRegex = "^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
        let uuidPredicate = NSPredicate(format: "SELF MATCHES[c] %@", uuidRegex)
        return uuidPredicate.evaluate(with: uuid)
    }
    
    public static func validateAmount(_ amount: Double) -> Bool {
        return amount > 0 && amount.isFinite
    }
    
    public static func validateCurrency(_ currency: String) -> Bool {
        let validCurrencies = ["USD", "EUR", "GBP", "CAD", "AUD", "JPY", "CHF", "CNY"]
        return validCurrencies.contains(currency.uppercased())
    }
    
    // MARK: - String Utilities
    
    public static func sanitizeInput(_ input: String) -> String {
        return input
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&#x27;")
    }
    
    public static func sanitizeMetadata(_ metadata: [String: Any]) -> [String: Any] {
        var sanitized: [String: Any] = [:]
        
        for (key, value) in metadata {
            if let stringValue = value as? String {
                sanitized[key] = sanitizeInput(stringValue)
            } else if let arrayValue = value as? [Any] {
                sanitized[key] = arrayValue.map { item in
                    if let stringItem = item as? String {
                        return sanitizeInput(stringItem)
                    }
                    return item
                }
            } else if let dictValue = value as? [String: Any] {
                sanitized[key] = sanitizeMetadata(dictValue)
            } else {
                sanitized[key] = value
            }
        }
        
        return sanitized
    }
    
    public static func generateLicenseKey() -> String {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<32).map { _ in characters.randomElement()! })
    }
    
    public static func generateUUID() -> String {
        return UUID().uuidString
    }
    
    public static func capitalizeFirst(_ text: String) -> String {
        guard !text.isEmpty else { return text }
        return text.prefix(1).uppercased() + text.dropFirst().lowercased()
    }
    
    public static func toSnakeCase(_ text: String) -> String {
        let pattern = "([a-z])([A-Z])"
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: text.utf16.count)
        return regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: "$1_$2").lowercased()
    }
    
    public static func toPascalCase(_ text: String) -> String {
        return text.components(separatedBy: "_").map { $0.capitalized }.joined()
    }
    
    public static func truncateString(_ text: String, maxLength: Int) -> String {
        if text.count <= maxLength {
            return text
        }
        return String(text.prefix(maxLength - 3)) + "..."
    }
    
    public static func slugify(_ text: String) -> String {
        return text
            .lowercased()
            .replacingOccurrences(of: "[^a-z0-9\\s-]", with: "", options: .regularExpression)
            .replacingOccurrences(of: "\\s+", with: "-", options: .regularExpression)
            .replacingOccurrences(of: "-+", with: "-", options: .regularExpression)
            .trimmingCharacters(in: CharacterSet(charactersIn: "-"))
    }
    
    // MARK: - Date Utilities
    
    public static func formatTimestamp(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: date)
    }
    
    public static func parseTimestamp(_ timestamp: String) -> TimeInterval? {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: timestamp) else { return nil }
        return date.timeIntervalSince1970
    }
    
    public static func getCurrentTimestamp() -> TimeInterval {
        return Date().timeIntervalSince1970
    }
    
    public static func getCurrentDate() -> String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: Date())
    }
    
    // MARK: - Crypto Utilities
    
    public static func createWebhookSignature(payload: String, secret: String) -> String {
        let key = SymmetricKey(data: secret.data(using: .utf8)!)
        let signature = HMAC<SHA256>.authenticationCode(for: payload.data(using: .utf8)!, using: key)
        return Data(signature).map { String(format: "%02hhx", $0) }.joined()
    }
    
    public static func verifyWebhookSignature(payload: String, signature: String, secret: String) -> Bool {
        let expectedSignature = createWebhookSignature(payload: payload, secret: secret)
        return signature == expectedSignature
    }
    
    public static func sha256(_ data: String) -> String {
        let inputData = data.data(using: .utf8)!
        let hashed = SHA256.hash(data: inputData)
        return Data(hashed).map { String(format: "%02hhx", $0) }.joined()
    }
    
    public static func sha1(_ data: String) -> String {
        let inputData = data.data(using: .utf8)!
        let hashed = Insecure.SHA1.hash(data: inputData)
        return Data(hashed).map { String(format: "%02hhx", $0) }.joined()
    }
    
    public static func md5(_ data: String) -> String {
        let inputData = data.data(using: .utf8)!
        let hashed = Insecure.MD5.hash(data: inputData)
        return Data(hashed).map { String(format: "%02hhx", $0) }.joined()
    }
    
    // MARK: - Formatting Utilities
    
    public static func formatBytes(_ bytes: Int) -> String {
        let units = ["B", "KB", "MB", "GB", "TB"]
        var size = Double(bytes)
        var unitIndex = 0
        
        while size >= 1024 && unitIndex < units.count - 1 {
            size /= 1024
            unitIndex += 1
        }
        
        return String(format: "%.1f %@", size, units[unitIndex])
    }
    
    public static func formatDuration(_ seconds: TimeInterval) -> String {
        if seconds < 60 {
            return "\(Int(seconds))s"
        } else if seconds < 3600 {
            let minutes = Int(seconds / 60)
            let remainingSeconds = Int(seconds.truncatingRemainder(dividingBy: 60))
            return "\(minutes)m \(remainingSeconds)s"
        } else if seconds < 86400 {
            let hours = Int(seconds / 3600)
            let minutes = Int((seconds.truncatingRemainder(dividingBy: 3600)) / 60)
            return "\(hours)h \(minutes)m"
        } else {
            let days = Int(seconds / 86400)
            let hours = Int((seconds.truncatingRemainder(dividingBy: 86400)) / 3600)
            return "\(days)d \(hours)h"
        }
    }
    
    public static func formatPrice(_ price: Double, currency: String) -> String {
        return String(format: "%.4f %@", price, currency)
    }
    
    // MARK: - Array Utilities
    
    public static func chunkArray<T>(_ array: [T], chunkSize: Int) -> [[T]] {
        var chunks: [[T]] = []
        for i in stride(from: 0, to: array.count, by: chunkSize) {
            let chunk = Array(array[i..<min(i + chunkSize, array.count)])
            chunks.append(chunk)
        }
        return chunks
    }
    
    // MARK: - Validation Helpers
    
    public static func validateNotEmpty(_ value: String, fieldName: String) throws {
        if value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw LicenseChainError.validationError("\(fieldName) cannot be empty")
        }
    }
    
    public static func validatePositive(_ value: Double, fieldName: String) throws {
        if value <= 0 {
            throw LicenseChainError.validationError("\(fieldName) must be positive")
        }
    }
    
    public static func validateRange(_ value: Double, min: Double, max: Double, fieldName: String) throws {
        if value < min || value > max {
            throw LicenseChainError.validationError("\(fieldName) must be between \(min) and \(max)")
        }
    }
    
    // MARK: - JSON Utilities
    
    public static func jsonSerialize(_ object: Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    public static func jsonDeserialize<T: Codable>(_ jsonString: String, type: T.Type) -> T? {
        guard let data = jsonString.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
    
    public static func isValidJSON(_ jsonString: String) -> Bool {
        guard let data = jsonString.data(using: .utf8) else { return false }
        do {
            _ = try JSONSerialization.jsonObject(with: data, options: [])
            return true
        } catch {
            return false
        }
    }
    
    // MARK: - URL Utilities
    
    public static func isValidURL(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString) else { return false }
        return url.scheme == "http" || url.scheme == "https"
    }
    
    public static func urlEncode(_ string: String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? string
    }
    
    public static func urlDecode(_ string: String) -> String {
        return string.removingPercentEncoding ?? string
    }
}
