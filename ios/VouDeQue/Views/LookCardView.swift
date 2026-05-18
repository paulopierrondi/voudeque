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
                    .foregroundStyle(Color.fashionGold)

                VStack(alignment: .leading, spacing: 2) {
                    Text(look.userName ?? "Usuário")
                        .font(.runwayBody(size: 15, weight: .semibold))
                        .foregroundColor(.fashionChampagne)
                    Text(look.occasion)
                        .font(.runwayCaption())
                        .foregroundColor(.fashionChampagne.opacity(0.5))
                }

                Spacer()

                Text(look.createdAt, style: .relative)
                    .font(.runwayCaption())
                    .foregroundColor(.fashionChampagne.opacity(0.4))
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)

            // Look Image Placeholder / AsyncImage
            ZStack {
                Color.darkGradient
                    .frame(height: 260)
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                if let imageURL = look.imageURL, let url = URL(string: imageURL) {
                    AsyncImageView(url: url)
                        .frame(height: 260)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                } else {
                    Image(systemName: "sparkles")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                        .foregroundStyle(Color.fashionGold.opacity(0.3))
                }
            }
            .padding(.horizontal, 16)

            Text(look.description)
                .font(.runwayBody(size: 14))
                .foregroundColor(.fashionChampagne.opacity(0.85))
                .lineLimit(3)
                .padding(.horizontal, 16)

            HStack(spacing: 6) {
                ForEach(look.items.prefix(3)) { item in
                    HStack(spacing: 4) {
                        Circle()
                            .fill(colorForName(item.color))
                            .frame(width: 8, height: 8)
                        Text(item.name)
                            .font(.runwayCaption())
                            .foregroundColor(.fashionChampagne.opacity(0.8))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.fashionGold.opacity(0.08))
                    .cornerRadius(8)
                }
            }
            .padding(.horizontal, 16)

            HStack(spacing: 16) {
                Button(action: {
                    HapticFeedback.medium()
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
                            .font(.runwayCaption())
                    }
                    .foregroundStyle(hasVoted ? Color.fashionRose : Color.fashionChampagne.opacity(0.5))
                }

                Spacer()

                Button(action: {
                    HapticFeedback.light()
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 18))
                        .foregroundColor(.fashionChampagne.opacity(0.5))
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .runwayCard()
    }
}

#Preview {
    ZStack {
        Color.runwayBlack.ignoresSafeArea()
        ScrollView {
            LookCardView(look: .sample)
                .padding(.horizontal, 16)
        }
    }
}
