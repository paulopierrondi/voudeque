import SwiftUI

struct ErrorStateView: View {
    let message: String
    let retryAction: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color.vdqLinen)
                    .frame(width: 88, height: 88)

                Image(systemName: "exclamationmark.triangle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.vdqAccent)
            }

            Text("Algo deu errado")
                .font(.vdqSerif(20, italic: true))
                .foregroundColor(.vdqInk)
                .multilineTextAlignment(.center)

            Text(message)
                .font(.vdqSans(15))
                .foregroundColor(.vdqAsh)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .padding(.horizontal, 32)

            Button(action: {
                HapticFeedback.medium()
                retryAction()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 14, weight: .semibold))
                    Text("Tentar novamente")
                        .font(.vdqSerif(15, italic: true))
                }
                .foregroundColor(.vdqBone)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.vdqInk)
            }
            .pressAnimation()
            .padding(.horizontal, 32)
            .padding(.top, 8)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.vdqBone.ignoresSafeArea())
    }
}

#Preview {
    ErrorStateView(message: "Nao foi possivel carregar os looks. Verifique sua conexao.") {
        print("Retry tapped")
    }
}
