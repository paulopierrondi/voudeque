import SwiftUI

struct FeedView: View {
    @State private var looks: [Look] = []
    @State private var isLoading = true
    @State private var hasError = false
    @State private var errorMessage = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Section opener
                VStack(alignment: .leading, spacing: 8) {
                    Text("O que veste o Brasil esta semana.")
                        .font(.vdqDisplay(28, italic: true))
                        .foregroundColor(.vdqInk)

                    Text("VOL. 04 · N.º 048 · MAIO · 2026")
                        .vdqEyebrow()
                        .padding(.top, 4)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 24)

                Rectangle()
                    .fill(Color.vdqRule)
                    .frame(height: 1 / UIScreen.main.scale)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)

                if isLoading {
                    ShimmerLoadingView()
                        .frame(maxWidth: .infinity, minHeight: 300)
                } else if hasError {
                    ErrorStateView(message: errorMessage) {
                        Task {
                            await loadFeed()
                        }
                    }
                    .frame(minHeight: 400)
                } else if looks.isEmpty {
                    EmptyStateView(
                        icon: "heart.slash",
                        title: "Nenhum look ainda",
                        message: "Seja o primeiro a criar e compartilhar um look com a comunidade.",
                        actionTitle: "Criar Look",
                        action: {
                            // Tab switch would require binding, keeping simple
                        }
                    )
                    .frame(minHeight: 400)
                } else {
                    LazyVStack(spacing: 32) {
                        ForEach(Array(looks.enumerated()), id: \.element.id) { index, look in
                            FeedPostView(index: index, look: look)
                                .padding(.horizontal, 20)
                        }
                    }
                }

                Spacer(minLength: 30)
            }
        }
        .background(Color.vdqBone.ignoresSafeArea())
        .refreshable {
            await loadFeed()
        }
        .task {
            await loadFeed()
        }
    }

    private func loadFeed() async {
        isLoading = true
        hasError = false
        do {
            looks = try await APIService.shared.fetchFeed()
        } catch {
            hasError = true
            errorMessage = error.localizedDescription
            print("Error loading feed: \(error)")
        }
        isLoading = false
    }
}

struct FeedPostView: View {
    let index: Int
    let look: Look

    var romanNumeral: String {
        let numerals = ["I.", "II.", "III.", "IV.", "V.", "VI.", "VII.", "VIII.", "IX.", "X."]
        return numerals[index % numerals.count]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Roman numeral + byline
            HStack(alignment: .top, spacing: 12) {
                Text(romanNumeral)
                    .font(.vdqDisplay(24, italic: true))
                    .foregroundColor(.vdqAsh2)

                VStack(alignment: .leading, spacing: 4) {
                    Text(look.userName ?? "Usuario")
                        .font(.vdqSerif(15, italic: true))
                        .foregroundColor(.vdqInk)
                    Text("@\((look.userName ?? "usuario").lowercased().replacingOccurrences(of: " ", with: ""))")
                        .font(.vdqMono(11))
                        .foregroundColor(.vdqAsh)
                }

                Spacer()
            }

            // Figure placeholder
            ZStack {
                Rectangle()
                    .fill(Color.vdqLinen)
                    .aspectRatio(4/5, contentMode: .fit)
                    .overlay(
                        VStack(spacing: 8) {
                            Text("LOOK · \(look.occasion.uppercased())")
                                .font(.vdqMono(10))
                                .foregroundColor(.vdqAsh)
                        }
                    )

                if let imageURL = look.imageURL, let url = URL(string: imageURL) {
                    AsyncImageView(url: url)
                        .aspectRatio(4/5, contentMode: .fit)
                }
            }

            // Description
            Text(look.description)
                .font(.vdqSans(15))
                .foregroundColor(.vdqInk2)
                .lineSpacing(4)
                .lineLimit(3)

            // Actions
            HStack(spacing: 20) {
                Button(action: {
                    HapticFeedback.light()
                }) {
                    Text("Votar")
                        .font(.vdqMono(11))
                        .foregroundColor(.vdqAsh)
                }

                Button(action: {
                    HapticFeedback.light()
                }) {
                    Text("Compartilhar")
                        .font(.vdqMono(11))
                        .foregroundColor(.vdqAsh)
                }

                Button(action: {
                    HapticFeedback.light()
                }) {
                    Text("Guardar")
                        .font(.vdqMono(11))
                        .foregroundColor(.vdqAsh)
                }

                Spacer()

                Text("\(look.votes)")
                    .font(.vdqMono(11))
                    .foregroundColor(.vdqAsh)
            }

            Rectangle()
                .fill(Color.vdqRule)
                .frame(height: 1 / UIScreen.main.scale)
                .padding(.top, 8)
        }
    }
}

#Preview {
    FeedView()
}
