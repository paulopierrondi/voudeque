import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color.fashionGold.opacity(0.08))
                    .frame(width: 100, height: 100)

                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(Color.goldGradient)
            }

            Text(title)
                .font(.runwayTitle(size: 20))
                .foregroundColor(.fashionChampagne)
                .multilineTextAlignment(.center)

            Text(message)
                .font(.runwayBody(size: 15))
                .foregroundColor(.fashionChampagne.opacity(0.6))
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .padding(.horizontal, 32)

            if let actionTitle = actionTitle, let action = action {
                Button(action: {
                    HapticFeedback.medium()
                    action()
                }) {
                    Text(actionTitle)
                        .font(.runwayTitle(size: 16, weight: .bold))
                        .runwayButton()
                }
                .pressAnimation()
                .padding(.horizontal, 32)
                .padding(.top, 8)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.runwayBlack.ignoresSafeArea())
    }
}

#Preview {
    EmptyStateView(
        icon: "heart.slash",
        title: "Nenhum look ainda",
        message: "Vote nos looks da comunidade ou crie o seu primeiro look para aparecer aqui.",
        actionTitle: "Criar Look",
        action: {}
    )
}
