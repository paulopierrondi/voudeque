import SwiftUI

struct HomeView: View {
    @State private var stats = UserStats.sample
    @State private var dailyChallenge = Challenge.sample
    @State private var isLoading = false
    @State private var loadError = false
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeRemaining = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Editorial Hero Header
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("VouDeQue")
                            .font(.runwayDisplay(size: 34, weight: .medium))
                            .foregroundStyle(Color.goldGradient)
                        Text("Seu estilista de IA")
                            .font(.runwayBody(size: 15))
                            .foregroundColor(.fashionChampagne.opacity(0.6))
                    }
                    Spacer()
                    Image(systemName: "sparkle")
                        .font(.system(size: 24))
                        .foregroundStyle(Color.fashionGold)
                }
                .padding(.horizontal, 20)

                // Quick Stats
                HStack(spacing: 12) {
                    StatCard(title: "Looks", value: "\(stats.looksGenerated)", icon: "sparkles.rectangle.stack")
                    StatCard(title: "Votos", value: "\(stats.votesReceived)", icon: "heart.fill")
                    StatCard(title: "Ranking", value: "#\(stats.currentRank)", icon: "trophy.fill")
                }
                .padding(.horizontal, 20)

                // Featured Daily Challenge
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Label("Desafio do Dia", systemImage: "flame.fill")
                            .font(.runwayTitle(size: 16))
                            .foregroundColor(.fashionChampagne)
                        Spacer()
                        HStack(spacing: 4) {
                            Image(systemName: "person.2.fill")
                                .font(.runwayCaption())
                            Text("\(dailyChallenge.participants)")
                                .font(.runwayCaption())
                        }
                        .foregroundColor(.fashionGold)
                    }

                    Text(dailyChallenge.title)
                        .font(.runwayTitle(size: 20))
                        .foregroundColor(.fashionChampagne)

                    Text(dailyChallenge.description)
                        .font(.runwayBody(size: 14))
                        .foregroundColor(.fashionChampagne.opacity(0.7))
                        .lineLimit(2)
                        .lineSpacing(3)

                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.runwayCaption())
                            Text(timeRemaining)
                                .font(.runwayCaption())
                                .monospacedDigit()
                        }
                        .foregroundColor(.fashionRose)

                        Spacer()

                        Text("Tema: \(dailyChallenge.theme)")
                            .runwayTag()
                    }
                }
                .padding(20)
                .runwayCard()
                .padding(.horizontal, 20)
                .onReceive(timer) { _ in
                    timeRemaining = Date().timeRemainingString(to: dailyChallenge.endsAt)
                }
                .onAppear {
                    timeRemaining = Date().timeRemainingString(to: dailyChallenge.endsAt)
                }

                // CTA Generate Look
                NavigationLink(destination: GenerateLookView()) {
                    HStack(spacing: 12) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 22))
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Gerar Novo Look")
                                .font(.runwayTitle(size: 17))
                            Text("Foto + IA = estilo perfeito")
                                .font(.runwayBody(size: 13))
                                .opacity(0.85)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.fashionChampagne)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 18)
                    .background(Color.goldGradient)
                    .cornerRadius(14)
                }
                .pressAnimation()
                .padding(.horizontal, 20)

                // Recent Activity
                VStack(alignment: .leading, spacing: 14) {
                    Text("Atividade Recente")
                        .font(.runwayTitle(size: 18))
                        .foregroundColor(.fashionChampagne)
                        .padding(.horizontal, 20)

                    LookCardView(look: .sample)
                        .padding(.horizontal, 20)
                }

                Spacer(minLength: 30)
            }
            .padding(.top, 16)
        }
        .background(Color.runwayBlack.ignoresSafeArea())
        .task {
            await loadDailyChallenge()
        }
    }
    
    private func loadDailyChallenge() async {
        do {
            dailyChallenge = try await APIService.shared.fetchDailyChallenge()
            loadError = false
        } catch {
            loadError = true
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundStyle(Color.fashionGold)
            Text(value)
                .font(.runwayTitle(size: 20))
                .foregroundColor(.fashionChampagne)
            Text(title)
                .font(.runwayCaption())
                .foregroundColor(.fashionChampagne.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .runwayCard()
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
