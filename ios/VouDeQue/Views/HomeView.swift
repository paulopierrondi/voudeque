import SwiftUI

struct HomeView: View {
    @State private var dailyChallenge = Challenge.sample
    @State private var isLoading = false
    @State private var loadError = false
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeRemaining = ""

    let tocEntries = [
        ("O briefing de hoje.", "014"),
        ("Editorial: look do dia", "022"),
        ("O que veste o Brasil", "034"),
        ("Arquivo pessoal", "048")
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Folio
                Text("VOL. 04 · N.º 048 · MAIO · 2026")
                    .vdqEyebrow()
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 16)

                // Masthead
                Text("VOUDEQUE")
                    .font(.vdqMasthead(42))
                    .foregroundColor(.vdqInk)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)

                // Cover Story
                VStack(alignment: .leading, spacing: 12) {
                    ZStack(alignment: .bottomLeading) {
                        Rectangle()
                            .fill(Color.vdqLinen)
                            .aspectRatio(3/4, contentMode: .fit)
                            .overlay(
                                VStack(spacing: 8) {
                                    Text("LOOK")
                                        .font(.vdqMono(11))
                                        .foregroundColor(.vdqAsh)
                                    Text("+")
                                        .font(.vdqDisplay(48, italic: true))
                                        .foregroundColor(.vdqAsh2)
                                }
                            )

                        VStack(alignment: .leading, spacing: 6) {
                            Text("O look do dia")
                                .font(.vdqSerif(14, italic: true))
                                .foregroundColor(.vdqAsh)
                            Text("Casual chic com\njeans wide leg")
                                .font(.vdqDisplay(28, italic: true))
                                .foregroundColor(.vdqInk)
                                .lineSpacing(2)
                        }
                        .padding(16)
                        .background(
                            LinearGradient(
                                colors: [.vdqBone.opacity(0.0), .vdqBone.opacity(0.9)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 28)

                // Table of Contents
                VStack(alignment: .leading, spacing: 0) {
                    Text("Nesta edição")
                        .font(.vdqSerif(20, italic: true))
                        .foregroundColor(.vdqInk)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 12)

                    Rectangle()
                        .fill(Color.vdqRule)
                        .frame(height: 1 / UIScreen.main.scale)
                        .padding(.horizontal, 20)

                    ForEach(tocEntries.indices, id: \.self) { index in
                        HStack(alignment: .firstTextBaseline) {
                            Text(tocEntries[index].0)
                                .font(.vdqSans(15, weight: .regular))
                                .foregroundColor(.vdqInk2)
                            Spacer()
                            Text("P. \(tocEntries[index].1)")
                                .font(.vdqMono(11))
                                .foregroundColor(.vdqAsh)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)

                        Rectangle()
                            .fill(Color.vdqRule)
                            .frame(height: 1 / UIScreen.main.scale)
                            .padding(.horizontal, 20)
                    }
                }
                .padding(.bottom, 28)

                // CTA Generate Look
                NavigationLink(destination: GenerateLookView()) {
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Fechar a edição")
                                .font(.vdqSerif(17, italic: true))
                            Text("Novo look em ≈ 2,8 s")
                                .font(.vdqMono(11))
                                .foregroundColor(.vdqAsh)
                        }
                        Spacer()
                        Text("→")
                            .font(.vdqSans(18, weight: .medium))
                    }
                    .foregroundColor(.vdqBone)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 18)
                    .background(Color.vdqInk)
                }
                .pressAnimation()
                .padding(.horizontal, 20)
                .padding(.bottom, 24)

                Spacer(minLength: 30)
            }
            .padding(.top, 16)
        }
        .background(Color.vdqBone.ignoresSafeArea())
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

#Preview {
    NavigationStack {
        HomeView()
    }
}
