import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentPage = 0

    var body: some View {
        ZStack {
            Color.runwayBlack.ignoresSafeArea()

            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPage(
                        image: "sparkles",
                        title: "Bem-vinda ao\nVouDeQue",
                        description: "Sua stylista pessoal de IA. Crie looks únicos para qualquer ocasião em segundos."
                    )
                    .tag(0)

                    OnboardingPage(
                        image: "camera.fill",
                        title: "Como Funciona",
                        description: "Escolha a ocasião, adicione uma foto opcional e deixe nossa IA criar o look perfeito para você."
                    )
                    .tag(1)

                    OnboardingPage(
                        image: "heart.fill",
                        title: "Compartilhe e Vote",
                        description: "Participe de desafios diários, compartilhe seus looks e vote nos favoritos da comunidade."
                    )
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                // Page Indicators
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Capsule()
                            .fill(currentPage == index ? Color.fashionGold : Color.fashionGold.opacity(0.3))
                            .frame(width: currentPage == index ? 24 : 8, height: 8)
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
                    Text(currentPage < 2 ? "Continuar" : "Começar")
                        .font(.runwayTitle(size: 17, weight: .bold))
                        .runwayButton()
                }
                .pressAnimation()
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
}

struct OnboardingPage: View {
    let image: String
    let title: String
    let description: String

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color.fashionGold.opacity(0.08))
                    .frame(width: 160, height: 160)

                Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    .foregroundStyle(Color.goldGradient)
            }

            VStack(spacing: 16) {
                Text(title)
                    .font(.runwayDisplay(size: 32, weight: .medium))
                    .foregroundColor(.fashionChampagne)
                    .multilineTextAlignment(.center)

                Text(description)
                    .font(.runwayBody(size: 16))
                    .foregroundColor(.fashionChampagne.opacity(0.7))
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
