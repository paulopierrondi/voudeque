import Foundation
import Observation

@Observable
class APIService {
    static let shared = APIService()

    private init() {}

    func generateLook(occasion: String, notes: String) async throws -> Look {
        try await Task.sleep(nanoseconds: 2_000_000_000)

        let sampleLooks: [Look] = [
            Look(
                id: UUID(),
                imageURL: nil,
                description: "Look \(occasion.lowercased()) sofisticado com peças em tons neutros. A combinação traz elegância natural e versatilidade.",
                items: [
                    LookItem(name: "Calça Alfaiataria", category: "Bottom", color: "Bege", reason: "Base elegante e atemporal"),
                    LookItem(name: "Camisa de Seda", category: "Top", color: "Branco", reason: "Toque refinado"),
                    LookItem(name: "Mocassim", category: "Shoes", color: "Marrom", reason: "Conforto e estilo"),
                    LookItem(name: "Bolsa Estruturada", category: "Accessory", color: "Preto", reason: "Praticidade e sofisticação")
                ],
                occasion: occasion,
                votes: 0,
                createdAt: Date(),
                userName: "Você",
                userAvatar: nil
            ),
            Look(
                id: UUID(),
                imageURL: nil,
                description: "Look \(occasion.lowercased()) com peças statement e cores vibrantes. Ideal para quem gosta de se destacar.",
                items: [
                    LookItem(name: "Saia Plissada", category: "Bottom", color: "Vermelho", reason: "Cor impactante"),
                    LookItem(name: "Blusa de Gola Alta", category: "Top", color: "Preto", reason: "Equilíbrio com a saia"),
                    LookItem(name: "Ankle Boot", category: "Shoes", color: "Preto", reason: "Atitude e versatilidade"),
                    LookItem(name: "Brincos Statement", category: "Accessory", color: "Dourado", reason: "Brilho e personalidade")
                ],
                occasion: occasion,
                votes: 0,
                createdAt: Date(),
                userName: "Você",
                userAvatar: nil
            ),
            Look(
                id: UUID(),
                imageURL: nil,
                description: "Look \(occasion.lowercased()) minimalista com foco em texturas e cortes impecáveis. Less is more.",
                items: [
                    LookItem(name: "Macacão", category: "One Piece", color: "Preto", reason: "Peça única elegante"),
                    LookItem(name: "Scarpin", category: "Shoes", color: "Preto", reason: "Alongamento da silhueta"),
                    LookItem(name: "Relógio Minimalista", category: "Accessory", color: "Prata", reason: "Toque refinado")
                ],
                occasion: occasion,
                votes: 0,
                createdAt: Date(),
                userName: "Você",
                userAvatar: nil
            )
        ]

        return sampleLooks.randomElement() ?? sampleLooks[0]
    }

    func fetchFeed() async throws -> [Look] {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return Look.sampleFeed
    }

    func fetchDailyChallenge() async throws -> Challenge {
        try await Task.sleep(nanoseconds: 800_000_000)
        return Challenge.sample
    }

    func voteLook(id: UUID) async throws -> Int {
        try await Task.sleep(nanoseconds: 500_000_000)
        return Int.random(in: 10...999)
    }

    func fetchUserStats() async throws -> UserStats {
        try await Task.sleep(nanoseconds: 600_000_000)
        return UserStats.sample
    }
}
