import SwiftUI

struct ErrorStateView: View {
    let message: String
    let retryAction: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color.fashionRose.opacity(0.1))
                    .frame(width: 100, height: 100)

                Image(systemName: "exclamationmark.triangle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.fashionRose)
            }

            Text("Algo deu errado")
                .font(.runwayTitle(size: 20))
                .foregroundColor(.fashionChampagne)
                .multilineTextAlignment(.center)

            Text(message)
                .font(.runwayBody(size: 15))
                .foregroundColor(.fashionChampagne.opacity(0.6))
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .padding(.horizontal, 32)

            Button(action: {
                HapticFeedback.medium()
                retryAction()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Tentar novamente")
                        .font(.runwayTitle(size: 16, weight: .bold))
                }
                .runwayButton()
            }
            .pressAnimation()
            .padding(.horizontal, 32)
            .padding(.top, 8)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.runwayBlack.ignoresSafeArea())
    }
}

#Preview {
    ErrorStateView(message: "Não foi possível carregar os looks. Verifique sua conexão.") {
        print("Retry tapped")
    }
}
