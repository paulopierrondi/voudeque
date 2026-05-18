import Foundation

struct LookItem: Identifiable, Codable, Equatable {
    let id = UUID()
    let name: String
    let category: String
    let color: String
    let reason: String
}

struct Look: Identifiable, Codable, Equatable {
    let id: UUID
    let imageURL: String?
    let description: String
    let items: [LookItem]
    let occasion: String
    var votes: Int
    let createdAt: Date
    let userName: String?
    let userAvatar: String?
}

struct Challenge: Identifiable, Codable, Equatable {
    let id: UUID
    let title: String
    let description: String
    let theme: String
    let endsAt: Date
    let participants: Int
    let topLooks: [Look]
}

struct UserStats: Codable, Equatable {
    let looksGenerated: Int
    let votesReceived: Int
    let currentRank: Int
}

extension Look {
    static var sample: Look {
        Look(
            id: UUID(),
            imageURL: nil,
            description: "Look casual chic com calça jeans wide leg, blazer oversized e tênis branco. Perfeito para um dia de trabalho criativo.",
            items: [
                LookItem(name: "Calça Jeans Wide Leg", category: "Bottom", color: "Azul Claro", reason: "Confortável e elegante"),
                LookItem(name: "Blazer Oversized", category: "Outerwear", color: "Bege", reason: "Traz estrutura ao look"),
                LookItem(name: "Tênis Branco", category: "Shoes", color: "Branco", reason: "Toque despojado"),
                LookItem(name: "Blusa de Seda", category: "Top", color: "Branco", reason: "Leveza e sofisticação")
            ],
            occasion: "Trabalho",
            votes: 124,
            createdAt: Date(),
            userName: "Maria Silva",
            userAvatar: nil
        )
    }

    static var sampleFeed: [Look] {
        [
            Look(
                id: UUID(),
                imageURL: nil,
                description: "Look minimalista com tons de preto e branco.",
                items: [
                    LookItem(name: "Vestido Midi", category: "Dress", color: "Preto", reason: "Base elegante"),
                    LookItem(name: "Sandália Rasteira", category: "Shoes", color: "Preto", reason: "Conforto diário")
                ],
                occasion: "Casual",
                votes: 89,
                createdAt: Date().addingTimeInterval(-3600),
                userName: "Ana Paula",
                userAvatar: nil
            ),
            Look(
                id: UUID(),
                imageURL: nil,
                description: "Look festa com brilho e elegância para noite.",
                items: [
                    LookItem(name: "Vestido de Paetê", category: "Dress", color: "Prata", reason: "Brilho para a festa"),
                    LookItem(name: "Salto Alto", category: "Shoes", color: "Prata", reason: "Altura e elegância")
                ],
                occasion: "Festa",
                votes: 256,
                createdAt: Date().addingTimeInterval(-7200),
                userName: "Carolina",
                userAvatar: nil
            ),
            Look(
                id: UUID(),
                imageURL: nil,
                description: "Look academia com tecnologia e estilo.",
                items: [
                    LookItem(name: "Legging", category: "Bottom", color: "Rosa", reason: "Conforto e estilo"),
                    LookItem(name: "Top Esportivo", category: "Top", color: "Rosa", reason: "Suporte e respiração")
                ],
                occasion: "Academia",
                votes: 45,
                createdAt: Date().addingTimeInterval(-10800),
                userName: "Beatriz",
                userAvatar: nil
            )
        ]
    }
}

extension Challenge {
    static var sample: Challenge {
        Challenge(
            id: UUID(),
            title: "Desafio do Dia",
            description: "Crie um look monocromático usando apenas tons de azul. Mostre sua criatividade!",
            theme: "Monocromático Azul",
            endsAt: Date().addingTimeInterval(86400),
            participants: 342,
            topLooks: Look.sampleFeed
        )
    }
}

extension UserStats {
    static var sample: UserStats {
        UserStats(looksGenerated: 47, votesReceived: 1283, currentRank: 15)
    }
}
