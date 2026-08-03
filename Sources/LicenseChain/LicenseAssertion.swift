import Foundation
import JOSESwift

/// RS256 `license_token` verification via JWKS (parity with Node `verifyLicenseAssertionJwt`).
public enum LicenseChainLicenseAssertion {
    public static let licenseTokenUseClaim = "licensechain_license_v1"

    public struct VerifyOptions {
        public var expectedAppId: String?
        public var issuer: String?
        public init(expectedAppId: String? = nil, issuer: String? = nil) {
            self.expectedAppId = expectedAppId
            self.issuer = issuer
        }
    }

    public static func verifyLicenseAssertionJwt(
        token: String,
        jwksUrl: String,
        options: VerifyOptions = VerifyOptions()
    ) throws -> [String: Any] {
        let trimmed = token.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            throw LicenseChainError.validationError("empty token")
        }
        let jwksTrimmed = jwksUrl.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !jwksTrimmed.isEmpty else {
            throw LicenseChainError.validationError("empty jwksUrl")
        }

        let kid = try jwtKid(fromCompactJwt: trimmed)
        let jwksData = try syncFetch(urlString: jwksTrimmed)
        guard let jwksTop = try JSONSerialization.jsonObject(with: jwksData) as? [String: Any],
              let keys = jwksTop["keys"] as? [[String: Any]] else {
            throw LicenseChainError.invalidResponse
        }

        let keyDict: [String: Any]
        if let kid = kid {
            guard let match = keys.first(where: { ($0["kty"] as? String) == "RSA" && ($0["kid"] as? String) == kid }) else {
                throw LicenseChainError.validationError("no matching RSA JWK for kid")
            }
            keyDict = match
        } else {
            guard let first = keys.first(where: { ($0["kty"] as? String) == "RSA" }) else {
                throw LicenseChainError.validationError("no RSA key in JWKS")
            }
            keyDict = first
        }

        let keyJson = try JSONSerialization.data(withJSONObject: keyDict)
        let rsaJwk = try RSAPublicKey(data: keyJson)
        let secKey = try rsaJwk.converted(to: SecKey.self)

        let jws = try JWS(compactSerialization: trimmed)
        guard jws.header.algorithm == .RS256 else {
            throw LicenseChainError.validationError("expected RS256")
        }
        let verifier = Verifier(signatureAlgorithm: .RS256, publicKey: secKey)!
        let payload = try jws.validate(using: verifier).payload
        guard let obj = try JSONSerialization.jsonObject(with: payload.data()) as? [String: Any] else {
            throw LicenseChainError.invalidResponse
        }

        if let iss = options.issuer?.trimmingCharacters(in: .whitespacesAndNewlines), !iss.isEmpty {
            let tokenIss = obj["iss"] as? String
            if tokenIss != iss {
                throw LicenseChainError.validationError("issuer mismatch")
            }
        }

        let tu = obj["token_use"] as? String
        if tu != licenseTokenUseClaim {
            throw LicenseChainError.validationError("Invalid license token: expected token_use \"\(licenseTokenUseClaim)\"")
        }

        if let want = options.expectedAppId?.trimmingCharacters(in: .whitespacesAndNewlines), !want.isEmpty {
            let aud = obj["aud"]
            var ok = false
            if let s = aud as? String, s == want { ok = true }
            if let arr = aud as? [String], arr.contains(want) { ok = true }
            if !ok {
                throw LicenseChainError.validationError("Invalid license token: aud does not match expected app id")
            }
        }

        return obj
    }

    private static func jwtKid(fromCompactJwt token: String) throws -> String? {
        let parts = token.split(separator: ".")
        guard let head = parts.first else { return nil }
        var s = String(head)
        while s.count % 4 != 0 { s.append("=") }
        s = s.replacingOccurrences(of: "-", with: "+").replacingOccurrences(of: "_", with: "/")
        guard let data = Data(base64Encoded: s),
              let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }
        return json["kid"] as? String
    }

    private static func syncFetch(urlString: String) throws -> Data {
        guard let url = URL(string: urlString) else {
            throw LicenseChainError.invalidURL
        }
        var request = URLRequest(url: url)
        request.timeoutInterval = 20
        let sem = DispatchSemaphore(value: 0)
        var resultData: Data?
        var resultError: Error?
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            resultData = data
            resultError = error
            sem.signal()
        }
        task.resume()
        sem.wait()
        if let error = resultError {
            throw LicenseChainError.networkError(error)
        }
        guard let data = resultData, !data.isEmpty else {
            throw LicenseChainError.invalidResponse
        }
        return data
    }
}
