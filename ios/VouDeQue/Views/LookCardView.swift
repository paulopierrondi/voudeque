import SwiftUI

struct LookCardView: View {
    let look: Look
    var onVote: (() -> Void)?

    @State private var hasVoted = false
    @State private var voteCount: Int

    init(look: Look, onVote: (() -> Void)? = nil) {
        self.look = look
        self.onVote = onVote
        _voteCount = State(initialValue: look.votes)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .foregroundStyle(Color.vdqPurple)

                VStack(alignment: .leading, spacing: 2) {
                    Text(look.userName ?? "Usuário")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                    Text(look.occasion)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                }

                Spacer()

                Text(look.createdAt, style: .relative)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)

            // Look Image Placeholder
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [Color.vdqSurfaceLight, Color.vdqPurple.opacity(0.15)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 260)
                .overlay(
                    Image(systemName: "sparkles")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                        .foregroundStyle(Color.vdqPurple.opacity(0.5))
                )
                .padding(.horizontal, 16)

            Text(look.description)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.85))
                .lineLimit(3)
                .padding(.horizontal, 16)

            HStack(spacing: 6) {
                ForEach(look.items.prefix(3)) { item in
                    HStack(spacing: 4) {
                        Circle()
                            .fill(colorForName(item.color))
                            .frame(width: 8, height: 8)
                        Text(item.name)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.06))
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal, 16)

            HStack(spacing: 16) {
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        if !hasVoted {
                            voteCount += 1
                            hasVoted = true
                        } else {
                            voteCount -= 1
                            hasVoted = false
                        }
                        onVote?()
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: hasVoted ? "heart.fill" : "heart")
                            .font(.system(size: 18, weight: .semibold))
                        Text("\(voteCount)")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundStyle(hasVoted ? Color.vdqPink : Color.gray)
                }

                Spacer()

                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .vdqCardStyle()
    }

    private func colorForName(_ name: String) -> Color {
        switch name.lowercased() {
        case "preto": return .black
        case "branco": return .white
        case "azul", "azul claro": return .blue
        case "vermelho": return .red
        case "verde": return .green
        case "amarelo": return .yellow
        case "rosa": return .pink
        case "roxo", "lilás": return .purple
        case "laranja": return .orange
        case "cinza": return .gray
        case "bege", "marrom", "camelo": return Color(hex: "C4A484")
        case "prata", "dourado": return Color(hex: "C0C0C0")
        default: return .gray
        }
    }
}

#Preview {
    ZStack {
        Color.vdqBackground.ignoresSafeArea()
        ScrollView {
            LookCardView(look: .sample)
                .padding(.horizontal, 16)
        }
    }
}
