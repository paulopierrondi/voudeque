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
                            .font(.runwayDisplay(size: 28))
                            .foregroundColor(.fashionChampagne)
                        Text("Compita e evolua seu estilo")
                            .font(.runwayBody(size: 15))
                            .foregroundColor(.fashionChampagne.opacity(0.6))
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
                                .font(.runwayCaption())
                            Text("DESAFIO ATIVO")
                                .font(.runwayCaption(weight: .bold))
                        }
                        .foregroundColor(.fashionGold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.fashionGold.opacity(0.12))
                        .cornerRadius(8)

                        Spacer()

                        HStack(spacing: 4) {
                            Image(systemName: "person.2.fill")
                                .font(.runwayCaption())
                            Text("\(challenge.participants) participantes")
                                .font(.runwayCaption())
                        }
                        .foregroundColor(.fashionChampagne.opacity(0.5))
                    }

                    Text(challenge.title)
                        .font(.runwayTitle(size: 22))
                        .foregroundColor(.fashionChampagne)

                    Text(challenge.description)
                        .font(.runwayBody(size: 15))
                        .foregroundColor(.fashionChampagne.opacity(0.75))
                        .lineSpacing(3)

                    // Theme
                    HStack(spacing: 6) {
                        Image(systemName: "tag.fill")
                            .font(.runwayCaption())
                            .foregroundColor(.fashionGold)
                        Text("Tema: \(challenge.theme)")
                            .font(.runwayBody(size: 14, weight: .medium))
                            .foregroundColor(.fashionGold)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color.fashionGold.opacity(0.1))
                    .cornerRadius(10)

                    // Countdown
                    HStack(spacing: 10) {
                        Image(systemName: "clock")
                            .font(.system(size: 18))
                            .foregroundColor(.fashionRose)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Tempo restante")
                                .font(.runwayCaption())
                                .foregroundColor(.fashionChampagne.opacity(0.5))
                            Text(timeRemaining)
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.fashionChampagne)
                                .monospacedDigit()
                        }
                    }
                    .padding(.top, 4)

                    Button(action: {
                        HapticFeedback.medium()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Participar do Desafio")
                                .font(.runwayTitle(size: 16, weight: .bold))
                        }
                        .runwayButton()
                    }
                    .pressAnimation()
                    .padding(.top, 4)
                }
                .padding(20)
                .runwayCard()
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
                            .font(.runwayTitle(size: 18))
                            .foregroundColor(.fashionChampagne)
                        Spacer()
                    }
                    .padding(.horizontal, 20)

                    if challenge.topLooks.isEmpty {
                        EmptyStateView(
                            icon: "trophy",
                            title: "Nenhum look enviado",
                            message: "Seja o primeiro a participar do desafio e aparecer no ranking."
                        )
                        .frame(height: 200)
                    } else {
                        VStack(spacing: 10) {
                            ForEach(challenge.topLooks.indices, id: \.self) { index in
                                RankingRow(rank: index + 1, look: challenge.topLooks[index])
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }

                Spacer(minLength: 30)
            }
            .padding(.top, 16)
        }
        .background(Color.runwayBlack.ignoresSafeArea())
    }
}

struct RankingRow: View {
    let rank: Int
    let look: Look

    var rankColor: Color {
        switch rank {
        case 1: return Color.fashionGold
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
                    .font(.runwayBody(size: 15, weight: .bold))
                    .foregroundColor(rankColor)
            }

            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundStyle(Color.fashionGold.opacity(0.7))

            VStack(alignment: .leading, spacing: 3) {
                Text(look.userName ?? "Usuário")
                    .font(.runwayBody(size: 15, weight: .semibold))
                    .foregroundColor(.fashionChampagne)
                Text(look.occasion)
                    .font(.runwayCaption())
                    .foregroundColor(.fashionChampagne.opacity(0.5))
            }

            Spacer()

            HStack(spacing: 4) {
                Image(systemName: "heart.fill")
                    .font(.runwayCaption())
                    .foregroundColor(.fashionRose)
                Text("\(look.votes)")
                    .font(.runwayBody(size: 14, weight: .bold))
                    .foregroundColor(.fashionChampagne)
            }
        }
        .padding(14)
        .background(Color.runwayCharcoal)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.fashionGold.opacity(0.1), lineWidth: 1)
        )
    }
}

#Preview {
    NavigationStack {
        ChallengesView()
    }
}
