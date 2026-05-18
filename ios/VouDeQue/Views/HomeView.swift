import SwiftUI

struct HomeView: View {
    @State private var stats = UserStats.sample
    @State private var dailyChallenge = Challenge.sample
    @State private var isLoading = false
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeRemaining = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Welcome Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("VouDeQue")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.vdqPurple, Color.vdqPink],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        Text("Seu estilista de IA")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Image(systemName: "sparkles")
                        .font(.system(size: 24))
                        .foregroundStyle(Color.vdqPurple)
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
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                        HStack(spacing: 4) {
                            Image(systemName: "person.2.fill")
                                .font(.system(size: 12))
                            Text("\(dailyChallenge.participants)")
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundColor(.orange)
                    }

                    Text(dailyChallenge.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)

                    Text(dailyChallenge.description)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(2)

                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.system(size: 13))
                            Text(timeRemaining)
                                .font(.system(size: 13, weight: .semibold))
                                .monospacedDigit()
                        }
                        .foregroundColor(.pink)

                        Spacer()

                        Text("Tema: \(dailyChallenge.theme)")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.purple)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.purple.opacity(0.15))
                            .cornerRadius(10)
                    }
                }
                .padding(20)
                .vdqCardStyle()
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
                                .font(.system(size: 17, weight: .bold))
                            Text("Foto + IA = estilo perfeito")
                                .font(.system(size: 13))
                                .opacity(0.85)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 18)
                    .background(
                        LinearGradient(
                            colors: [Color.vdqPurple, Color.vdqPink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(20)
                }
                .padding(.horizontal, 20)

                // Recent Activity
                VStack(alignment: .leading, spacing: 14) {
                    Text("Atividade Recente")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)

                    LookCardView(look: .sample)
                        .padding(.horizontal, 20)
                }

                Spacer(minLength: 30)
            }
            .padding(.top, 16)
        }
        .background(Color.vdqBackground.ignoresSafeArea())
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
                .foregroundStyle(Color.vdqPurple)
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .vdqCardStyle()
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
