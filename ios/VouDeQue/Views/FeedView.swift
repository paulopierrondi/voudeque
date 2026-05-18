import SwiftUI

struct FeedView: View {
    @State private var looks: [Look] = []
    @State private var isLoading = true

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Comunidade")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        Text("Descubra looks e vote nos favoritos")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)

                if isLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                            .tint(Color.vdqPurple)
                            .scaleEffect(1.2)
                        Text("Carregando looks...")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, minHeight: 300)
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
        .background(Color.vdqBackground.ignoresSafeArea())
        .refreshable {
            await loadFeed()
        }
        .task {
            await loadFeed()
        }
    }

    private func loadFeed() async {
        isLoading = true
        do {
            looks = try await APIService.shared.fetchFeed()
        } catch {
            print("Error loading feed: \(error)")
        }
        isLoading = false
    }
}

#Preview {
    FeedView()
}
