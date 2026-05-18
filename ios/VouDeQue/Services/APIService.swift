import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case http(Int, String)
    case decoding(Error)
    case network(Error)
    case noToken
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .http(let code, _):
            if code == 429 { return "Muitas requisições. Aguarde." }
            if code >= 500 { return "Serviço instável. Tente em segundos." }
            if code == 401 || code == 403 { return "Sessão expirada. Reinicie o app." }
            return "Erro \(code)"
        case .decoding:
            return "Resposta inesperada do servidor"
        case .network:
            return "Sem conexão. Verifique sua rede."
        case .noToken:
            return "Sessão não iniciada"
        }
    }
}

@MainActor
final class APIService {
    static let shared = APIService()
    
    private let baseURL: URL
    private var token: String?
    private let session: URLSession
    
    private init() {
        let raw = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String
            ?? "http://127.0.0.1:8000"
        self.baseURL = URL(string: raw)!
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.waitsForConnectivity = true
        self.session = URLSession(configuration: config)
    }
    
    // MARK: - Auth
    
    func ensureAuthenticated() async throws {
        if token != nil { return }
        try await authenticate()
    }
    
    func authenticate() async throws {
        let (data, response) = try await request(path: "/api/v1/auth/anonymous", method: "POST", authenticated: false)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw APIError.http((response as? HTTPURLResponse)?.statusCode ?? 0, "")
        }
        let result = try JSONDecoder().decode(AuthResponse.self, from: data)
        self.token = result.token
    }
    
    func clearAuth() {
        token = nil
    }
    
    // MARK: - Looks
    
    func generateLook(occasion: String, notes: String) async throws -> Look {
        try await ensureAuthenticated()
        let body = ["occasion": occasion, "style_notes": notes]
        let (data, _) = try await request(path: "/api/v1/looks/generate", method: "POST", body: body)
        let response = try JSONDecoder().decode(LookResponseDTO.self, from: data)
        return Look(
            id: UUID(uuidString: response.id) ?? UUID(),
            imageURL: URL(string: response.image_url),
            description: response.description,
            items: response.items.map { LookItem(name: $0.name, category: $0.category, color: $0.color, reason: $0.reason) },
            occasion: response.occasion,
            votes: response.votes,
            createdAt: ISO8601DateFormatter().date(from: response.created_at) ?? Date(),
            userName: "Você",
            userAvatar: nil
        )
    }
    
    func fetchFeed() async throws -> [Look] {
        try await ensureAuthenticated()
        let (data, _) = try await request(path: "/api/v1/looks/feed", method: "GET")
        let responses = try JSONDecoder().decode([LookResponseDTO].self, from: data)
        return responses.map { dto in
            Look(
                id: UUID(uuidString: dto.id) ?? UUID(),
                imageURL: URL(string: dto.image_url),
                description: dto.description,
                items: dto.items.map { LookItem(name: $0.name, category: $0.category, color: $0.color, reason: $0.reason) },
                occasion: dto.occasion,
                votes: dto.votes,
                createdAt: ISO8601DateFormatter().date(from: dto.created_at) ?? Date(),
                userName: "Usuário",
                userAvatar: nil
            )
        }
    }
    
    func voteLook(id: String) async throws -> Int {
        try await ensureAuthenticated()
        let body = ["look_id": id]
        let (data, _) = try await request(path: "/api/v1/looks/vote", method: "POST", body: body)
        let result = try JSONDecoder().decode(VoteResponse.self, from: data)
        return result.votes
    }
    
    // MARK: - Challenges
    
    func fetchDailyChallenge() async throws -> Challenge {
        try await ensureAuthenticated()
        let (data, _) = try await request(path: "/api/v1/challenges/daily", method: "GET")
        let dto = try JSONDecoder().decode(ChallengeResponseDTO.self, from: data)
        return Challenge(
            id: dto.id,
            title: dto.title,
            description: dto.description,
            theme: dto.theme,
            endsAt: ISO8601DateFormatter().date(from: dto.ends_at) ?? Date(),
            participants: dto.participants
        )
    }
    
    // MARK: - Account Deletion
    
    func deleteAccount() async throws {
        try await ensureAuthenticated()
        let (_, response) = try await request(path: "/api/v1/users/me", method: "DELETE")
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw APIError.http((response as? HTTPURLResponse)?.statusCode ?? 0, "")
        }
        clearAuth()
    }
    
    // MARK: - Private
    
    private func request(path: String, method: String, body: [String: String]? = nil, authenticated: Bool = true) async throws -> (Data, URLResponse) {
        guard let url = URL(string: path, relativeTo: baseURL) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        if authenticated {
            guard let token = token else { throw APIError.noToken }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        if let body = body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
                let bodyStr = String(data: data, encoding: .utf8) ?? ""
                throw APIError.http(http.statusCode, bodyStr)
            }
            return (data, response)
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.network(error)
        }
    }
}

// MARK: - DTOs

struct AuthResponse: Codable {
    let user_id: String
    let token: String
}

struct LookItemDTO: Codable {
    let name: String
    let category: String
    let color: String
    let reason: String
}

struct LookResponseDTO: Codable {
    let id: String
    let image_url: String
    let description: String
    let items: [LookItemDTO]
    let occasion: String
    let votes: Int
    let created_at: String
}

struct VoteResponse: Codable {
    let success: Bool
    let votes: Int
}

struct ChallengeResponseDTO: Codable {
    let id: String
    let title: String
    let description: String
    let theme: String
    let ends_at: String
    let participants: Int
}
