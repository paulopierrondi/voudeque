import SwiftUI

struct ChallengesView: View {
    @State private var challenge = Challenge.sample
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeRemaining = ""
    @State private var isLoading = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Desafios")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        Text("Compita e evolua seu estilo")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)

                // Current Challenge Card
                VStack(alignment: .leading, spacing: 16) {
                    // Badge
                    HStack {
                        HStack(spacing: 6) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 13))
                            Text("DESAFIO ATIVO")
                                .font(.system(size: 12, weight: .bold))
                        }
                        .foregroundColor(.orange)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.orange.opacity(0.15))
                        .cornerRadius(10)

                        Spacer()

                        HStack(spacing: 4) {
                            Image(systemName: "person.2.fill")
                                .font(.system(size: 12))
                            Text("\(challenge.participants) participantes")
                                .font(.system(size: 13, weight: .medium))
                        }
                        .foregroundColor(.gray)
                    }

                    Text(challenge.title)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)

                    Text(challenge.description)
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.75))
                        .lineSpacing(3)

                    // Theme
                    HStack(spacing: 6) {
                        Image(systemName: "tag.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.purple)
                        Text("Tema: \(challenge.theme)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.purple)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color.purple.opacity(0.12))
                    .cornerRadius(12)

                    // Countdown
                    HStack(spacing: 10) {
                        Image(systemName: "clock")
                            .font(.system(size: 18))
                            .foregroundColor(.pink)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Tempo restante")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            Text(timeRemaining)
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .monospacedDigit()
                        }
                    }
                    .padding(.top, 4)

                    Button(action: {}) {
                        HStack(spacing: 8) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Participar do Desafio")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [Color.vdqPurple, Color.vdqPink],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                    }
                    .padding(.top, 4)
                }
                .padding(20)
                .vdqCardStyle()
                .padding(.horizontal, 20)
                .onReceive(timer) { _ in
                    timeRemaining = Date().timeRemainingString(to: challenge.endsAt)
                }
                .onAppear {
                    timeRemaining = Date().timeRemainingString(to: challenge.endsAt)
                }

                // Top 3 Ranking
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Label("Top 3", systemImage: "trophy.fill")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.horizontal, 20)

                    VStack(spacing: 10) {
                        ForEach(challenge.topLooks.indices, id: \.self) { index in
                            RankingRow(rank: index + 1, look: challenge.topLooks[index])
                        }
                    }
                    .padding(.horizontal, 20)
                }

                Spacer(minLength: 30)
            }
            .padding(.top, 16)
        }
        .background(Color.vdqBackground.ignoresSafeArea())
    }
}

struct RankingRow: View {
    let rank: Int
    let look: Look

    var rankColor: Color {
        switch rank {
        case 1: return .yellow
        case 2: return Color(hex: "C0C0C0")
        case 3: return Color(hex: "CD7F32")
        default: return .gray
        }
    }

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(rankColor.opacity(0.15))
                    .frame(width: 36, height: 36)
                Text("\(rank)")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(rankColor)
            }

            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundStyle(Color.vdqPurple)

            VStack(alignment: .leading, spacing: 3) {
                Text(look.userName ?? "Usuário")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                Text(look.occasion)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }

            Spacer()

            HStack(spacing: 4) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 13))
                    .foregroundColor(.pink)
                Text("\(look.votes)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .padding(14)
        .background(Color.vdqSurface)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
    }
}

#Preview {
    NavigationStack {
        ChallengesView()
    }
}
