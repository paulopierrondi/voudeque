import SwiftUI

struct ChallengesView: View {
    @State private var challenge = Challenge.sample
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeRemaining = ""
    @State private var isLoading = false

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Desafios")
                            .font(.vdqDisplay(28, italic: true))
                            .foregroundColor(.vdqInk)
                        Text("Compita e evolua seu estilo")
                            .font(.vdqSans(15))
                            .foregroundColor(.vdqAsh)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)

                // Current Challenge Card
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("DESAFIO ATIVO")
                            .font(.vdqMono(10))
                            .foregroundColor(.vdqAccent)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .overlay(
                                Rectangle()
                                    .stroke(Color.vdqAccent.opacity(0.3), lineWidth: 1)
                            )

                        Spacer()

                        Text("\(challenge.participants) participantes")
                            .font(.vdqMono(10))
                            .foregroundColor(.vdqAsh)
                    }

                    Text(challenge.title)
                        .font(.vdqSerif(22, italic: true))
                        .foregroundColor(.vdqInk)

                    Text(challenge.description)
                        .font(.vdqSans(15))
                        .foregroundColor(.vdqInk2)
                        .lineSpacing(3)

                    Text("Tema: \(challenge.theme)")
                        .font(.vdqSerif(14, italic: true))
                        .foregroundColor(.vdqAccent)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .overlay(
                            Rectangle()
                                .stroke(Color.vdqAccent.opacity(0.2), lineWidth: 1)
                        )

                    HStack(spacing: 10) {
                        Text(timeRemaining)
                            .font(.vdqMono(14))
                            .foregroundColor(.vdqInk)
                            .monospacedDigit()
                    }
                    .padding(.top, 4)

                    Button(action: {
                        HapticFeedback.medium()
                    }) {
                        HStack(spacing: 8) {
                            Text("Participar do Desafio")
                                .font(.vdqSerif(16, italic: true))
                        }
                        .foregroundColor(.vdqBone)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.vdqInk)
                    }
                    .pressAnimation()
                    .padding(.top, 4)
                }
                .padding(20)
                .overlay(
                    Rectangle()
                        .stroke(Color.vdqRule, lineWidth: 1)
                )
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
                        Text("Top 3")
                            .font(.vdqSerif(18, italic: true))
                            .foregroundColor(.vdqInk)
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
        .background(Color.vdqBone.ignoresSafeArea())
    }
}

struct RankingRow: View {
    let rank: Int
    let look: Look

    var rankColor: Color {
        switch rank {
        case 1: return Color.vdqInk
        case 2: return Color.vdqAsh
        case 3: return Color.vdqAsh2
        default: return .gray
        }
    }

    var body: some View {
        HStack(spacing: 14) {
            Text("\(rank)")
                .font(.vdqMono(14))
                .foregroundColor(rankColor)
                .frame(width: 24, alignment: .leading)

            Image(systemName: "person.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 36, height: 36)
                .foregroundColor(.vdqAsh)

            VStack(alignment: .leading, spacing: 3) {
                Text(look.userName ?? "Usuario")
                    .font(.vdqSans(15, weight: .medium))
                    .foregroundColor(.vdqInk)
                Text(look.occasion)
                    .font(.vdqMono(10))
                    .foregroundColor(.vdqAsh)
            }

            Spacer()

            Text("\(look.votes)")
                .font(.vdqMono(12))
                .foregroundColor(.vdqAsh)
        }
        .padding(14)
        .overlay(
            Rectangle()
                .stroke(Color.vdqRule, lineWidth: 1)
        )
    }
}

#Preview {
    NavigationStack {
        ChallengesView()
    }
}
