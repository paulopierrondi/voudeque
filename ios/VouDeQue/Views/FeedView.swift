import SwiftUI

struct FeedView: View {
    @State private var looks: [Look] = []
    @State private var isLoading = true
    @State private var hasError = false
    @State private var errorMessage = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Comunidade")
                            .font(.runwayDisplay(size: 28))
                            .foregroundColor(.fashionChampagne)
                        Text("Descubra looks e vote nos favoritos")
                            .font(.runwayBody(size: 15))
                            .foregroundColor(.fashionChampagne.opacity(0.6))
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)

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
                    LazyVStack(spacing: 20) {
                        ForEach(looks) { look in
                            LookCardView(look: look)
                                .padding(.horizontal, 20)
                        }
                    }
                }

                Spacer(minLength: 30)
            }
            .padding(.top, 16)
        }
        .background(Color.runwayBlack.ignoresSafeArea())
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

#Preview {
    FeedView()
}
