import Foundation

/// Type-erased Codable wrapper so `[String: Any]` metadata can round-trip JSON.
struct AnyCodable: Codable {
    let value: Any

    init(_ value: Any) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            value = NSNull()
        } else if let bool = try? container.decode(Bool.self) {
            value = bool
        } else if let int = try? container.decode(Int.self) {
            value = int
        } else if let double = try? container.decode(Double.self) {
            value = double
        } else if let string = try? container.decode(String.self) {
            value = string
        } else if let array = try? container.decode([AnyCodable].self) {
            value = array.map(\.value)
        } else if let dict = try? container.decode([String: AnyCodable].self) {
            value = dict.mapValues(\.value)
        } else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unsupported JSON value"
            )
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch value {
        case is NSNull:
            try container.encodeNil()
        case let bool as Bool:
            try container.encode(bool)
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let string as String:
            try container.encode(string)
        case let array as [Any]:
            try container.encode(array.map { AnyCodable($0) })
        case let dict as [String: Any]:
            try container.encode(dict.mapValues { AnyCodable($0) })
        default:
            throw EncodingError.invalidValue(
                value,
                EncodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Unsupported JSON value"
                )
            )
        }
    }
}

enum JSONDictCoding {
    static func decode<K: CodingKey>(
        _ container: KeyedDecodingContainer<K>,
        forKey key: K
    ) throws -> [String: Any]? {
        guard container.contains(key), try container.decodeNil(forKey: key) == false else {
            return nil
        }
        let wrapped = try container.decode([String: AnyCodable].self, forKey: key)
        return wrapped.mapValues(\.value)
    }

    static func encode<K: CodingKey>(
        _ container: inout KeyedEncodingContainer<K>,
        _ value: [String: Any]?,
        forKey key: K
    ) throws {
        guard let value else { return }
        try container.encode(value.mapValues { AnyCodable($0) }, forKey: key)
    }
}

struct EmptyResponse: Codable {}
