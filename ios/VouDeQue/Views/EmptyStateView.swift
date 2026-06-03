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
                    .fill(Color.vdqLinen)
                    .frame(width: 88, height: 88)

                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.vdqAsh)
            }

            Text(title)
                .font(.vdqSerif(20, italic: true))
                .foregroundColor(.vdqInk)
                .multilineTextAlignment(.center)

            Text(message)
                .font(.vdqSans(15))
                .foregroundColor(.vdqAsh)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .padding(.horizontal, 32)

            if let actionTitle = actionTitle, let action = action {
                Button(action: {
                    HapticFeedback.medium()
                    action()
                }) {
                    Text(actionTitle)
                        .font(.vdqSerif(16, italic: true))
                        .foregroundColor(.vdqBone)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.vdqInk)
                }
                .pressAnimation()
                .padding(.horizontal, 32)
                .padding(.top, 8)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.vdqBone.ignoresSafeArea())
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
