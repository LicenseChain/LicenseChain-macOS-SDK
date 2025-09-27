import Foundation

public enum LicenseChainError: Error, LocalizedError {
    case invalidAPIKey
    case invalidURL
    case invalidResponse
    case networkError(Error)
    case httpError(statusCode: Int, message: String)
    case validationError(String)
    case authenticationError(String)
    case notFoundError(String)
    case rateLimitError(String)
    case serverError(String)
    case unknown
    
    public var errorDescription: String? {
        switch self {
        case .invalidAPIKey:
            return "Invalid API key provided"
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .httpError(let statusCode, let message):
            return "HTTP error \(statusCode): \(message)"
        case .validationError(let message):
            return "Validation error: \(message)"
        case .authenticationError(let message):
            return "Authentication error: \(message)"
        case .notFoundError(let message):
            return "Not found: \(message)"
        case .rateLimitError(let message):
            return "Rate limit exceeded: \(message)"
        case .serverError(let message):
            return "Server error: \(message)"
        case .unknown:
            return "Unknown error occurred"
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .invalidAPIKey:
            return "The API key is missing or invalid"
        case .invalidURL:
            return "The URL could not be constructed"
        case .invalidResponse:
            return "The server response could not be parsed"
        case .networkError:
            return "A network connection error occurred"
        case .httpError(let statusCode, _):
            return "HTTP request failed with status code \(statusCode)"
        case .validationError:
            return "The request data failed validation"
        case .authenticationError:
            return "Authentication failed"
        case .notFoundError:
            return "The requested resource was not found"
        case .rateLimitError:
            return "Too many requests were made"
        case .serverError:
            return "An internal server error occurred"
        case .unknown:
            return "An unexpected error occurred"
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .invalidAPIKey:
            return "Please check your API key and try again"
        case .invalidURL:
            return "Please check the base URL configuration"
        case .invalidResponse:
            return "Please try again later or contact support"
        case .networkError:
            return "Please check your internet connection and try again"
        case .httpError(let statusCode, _):
            switch statusCode {
            case 400:
                return "Please check your request parameters"
            case 401:
                return "Please check your API key"
            case 403:
                return "You don't have permission to access this resource"
            case 404:
                return "The requested resource was not found"
            case 429:
                return "Please wait before making another request"
            case 500...599:
                return "Please try again later or contact support"
            default:
                return "Please try again"
            }
        case .validationError:
            return "Please check your input data and try again"
        case .authenticationError:
            return "Please check your API key and try again"
        case .notFoundError:
            return "The requested resource may have been moved or deleted"
        case .rateLimitError:
            return "Please wait before making another request"
        case .serverError:
            return "Please try again later or contact support"
        case .unknown:
            return "Please try again or contact support"
        }
    }
}
