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
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.vdqAsh)

                VStack(alignment: .leading, spacing: 2) {
                    Text(look.userName ?? "Usuario")
                        .font(.vdqSans(14, weight: .medium))
                        .foregroundColor(.vdqInk)
                    Text(look.occasion)
                        .font(.vdqMono(10))
                        .foregroundColor(.vdqAsh)
                }

                Spacer()

                Text(look.createdAt, style: .relative)
                    .font(.vdqMono(10))
                    .foregroundColor(.vdqAsh2)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)

            // Look Image Placeholder / AsyncImage
            ZStack {
                Rectangle()
                    .fill(Color.vdqLinen)
                    .frame(height: 260)

                if let imageURL = look.imageURL, let url = URL(string: imageURL) {
                    AsyncImageView(url: url)
                        .frame(height: 260)
                } else {
                    Text("LOOK")
                        .font(.vdqMono(10))
                        .foregroundColor(.vdqAsh2)
                }
            }
            .padding(.horizontal, 16)

            Text(look.description)
                .font(.vdqSans(14))
                .foregroundColor(.vdqInk2)
                .lineLimit(3)
                .padding(.horizontal, 16)

            HStack(spacing: 6) {
                ForEach(look.items.prefix(3)) { item in
                    Text(item.name)
                        .font(.vdqMono(10))
                        .foregroundColor(.vdqAsh)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .overlay(
                            Rectangle()
                                .stroke(Color.vdqRule, lineWidth: 1)
                        )
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
                            .font(.system(size: 16, weight: .semibold))
                        Text("\(voteCount)")
                            .font(.vdqMono(11))
                    }
                    .foregroundColor(hasVoted ? .vdqAccent : .vdqAsh)
                }

                Spacer()

                Button(action: {
                    HapticFeedback.light()
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 16))
                        .foregroundColor(.vdqAsh)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .overlay(
            Rectangle()
                .stroke(Color.vdqRule, lineWidth: 1)
        )
    }
}

#Preview {
    ZStack {
        Color.vdqBone.ignoresSafeArea()
        ScrollView {
            LookCardView(look: .sample)
                .padding(.horizontal, 16)
        }
    }
}
