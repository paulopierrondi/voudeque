import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentPage = 0

    var body: some View {
        ZStack {
            Color.vdqBone.ignoresSafeArea()

            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPage(
                        number: "01",
                        title: "Edicao inaugural",
                        description: "Sua stylista pessoal de IA. Crie looks unicos para qualquer ocasiao em segundos."
                    )
                    .tag(0)

                    OnboardingPage(
                        number: "02",
                        title: "O briefing",
                        description: "Escolha a ocasiao, adicione uma foto opcional e deixe nossa IA criar o look perfeito para voce."
                    )
                    .tag(1)

                    OnboardingPage(
                        number: "03",
                        title: "Em pauta",
                        description: "Participe de desafios diarios, compartilhe seus looks e vote nos favoritos da comunidade."
                    )
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                // Ribbon motif
                ZStack {
                    Rectangle()
                        .fill(Color.vdqAccent)
                        .frame(height: 36)

                    Text("VOUDEQUE · ESTILO EM UM GESTO · VOUDEQUE · ESTILO EM UM GESTO · ")
                        .font(.vdqMono(10))
                        .foregroundColor(.vdqBone)
                        .lineLimit(1)
                }
                .padding(.bottom, 24)

                // Page Indicators
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Rectangle()
                            .fill(currentPage == index ? Color.vdqInk : Color.vdqInk.opacity(0.2))
                            .frame(width: currentPage == index ? 24 : 8, height: 2)
                            .animation(.spring(response: 0.3), value: currentPage)
                    }
                }
                .padding(.bottom, 24)

                // Action Button
                Button(action: {
                    HapticFeedback.medium()
                    if currentPage < 2 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        hasSeenOnboarding = true
                    }
                }) {
                    Text(currentPage < 2 ? "Continuar" : "Comecar")
                        .font(.vdqSerif(17, italic: true))
                        .foregroundColor(.vdqBone)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.vdqInk)
                }
                .pressAnimation()
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
}

struct OnboardingPage: View {
    let number: String
    let title: String
    let description: String

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // Wordmark
            Text("VOUDEQUE")
                .font(.vdqMasthead(48))
                .foregroundColor(.vdqInk)
                .padding(.bottom, 8)

            // Number
            Text(number)
                .font(.vdqDisplay(64, italic: true))
                .foregroundColor(.vdqAsh2)

            VStack(spacing: 16) {
                Text(title)
                    .font(.vdqDisplay(28, italic: true))
                    .foregroundColor(.vdqInk)
                    .multilineTextAlignment(.center)

                Text(description)
                    .font(.vdqSans(16))
                    .foregroundColor(.vdqAsh)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 32)
            }

            Spacer()
            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
}
