import SwiftUI

struct ProfileView: View {
    @State private var stats = UserStats.sample

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header with Settings
                HStack {
                    Spacer()
                    Button(action: {
                        HapticFeedback.light()
                    }) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.fashionChampagne.opacity(0.5))
                    }
                }
                .padding(.horizontal, 20)

                // Avatar & Name
                VStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(Color.fashionGold.opacity(0.1))
                            .frame(width: 100, height: 100)
                            .overlay(
                                Circle()
                                    .stroke(Color.fashionGold.opacity(0.2), lineWidth: 1)
                            )

                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)
                            .foregroundColor(.fashionChampagne)
                    }

                    Text("Maria Silva")
                        .font(.runwayDisplay(size: 24))
                        .foregroundColor(.fashionChampagne)

                    Text("@mariasilva")
                        .font(.runwayBody(size: 15))
                        .foregroundColor(.fashionChampagne.opacity(0.5))
                }

                // Stats Grid
                HStack(spacing: 12) {
                    ProfileStatCard(
                        value: "\(stats.looksGenerated)",
                        label: "Looks",
                        icon: "sparkles.rectangle.stack"
                    )
                    ProfileStatCard(
                        value: "\(stats.votesReceived)",
                        label: "Votos",
                        icon: "heart.fill"
                    )
                    ProfileStatCard(
                        value: "#\(stats.currentRank)",
                        label: "Ranking",
                        icon: "trophy.fill"
                    )
                }
                .padding(.horizontal, 20)

                // Recent Looks Section
                VStack(alignment: .leading, spacing: 14) {
                    Text("Looks Recentes")
                        .font(.runwayTitle(size: 18))
                        .foregroundColor(.fashionChampagne)
                        .padding(.horizontal, 20)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            ForEach(Look.sampleFeed) { look in
                                RecentLookCard(look: look)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }

                // Menu Items
                VStack(spacing: 2) {
                    ProfileMenuItem(icon: "bookmark.fill", title: "Looks Salvos")
                    ProfileMenuItem(icon: "flame.fill", title: "Meus Desafios")
                    ProfileMenuItem(icon: "arrow.up.heart.fill", title: "Looks Enviados")
                    ProfileMenuItem(icon: "bell.fill", title: "Notificações")
                    ProfileMenuItem(icon: "questionmark.circle.fill", title: "Ajuda")
                }
                .padding(.horizontal, 20)

                // Account Deletion
                DeleteAccountSection()
                    .padding(.horizontal, 20)

                Spacer(minLength: 30)
            }
            .padding(.top, 16)
        }
        .background(Color.runwayBlack.ignoresSafeArea())
    }
}

struct ProfileStatCard: View {
    let value: String
    let label: String
    let icon: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundStyle(Color.fashionGold)
            Text(value)
                .font(.runwayTitle(size: 22))
                .foregroundColor(.fashionChampagne)
            Text(label)
                .font(.runwayCaption())
                .foregroundColor(.fashionChampagne.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .runwayCard()
    }
}

struct RecentLookCard: View {
    let look: Look

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                Color.darkGradient
                    .frame(width: 140, height: 160)
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                if let imageURL = look.imageURL, let url = URL(string: imageURL) {
                    AsyncImageView(url: url)
                        .frame(width: 140, height: 160)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                } else {
                    Image(systemName: "sparkles")
                        .font(.system(size: 28))
                        .foregroundStyle(Color.fashionGold.opacity(0.3))
                }
            }

            Text(look.occasion)
                .font(.runwayBody(size: 13, weight: .semibold))
                .foregroundColor(.fashionChampagne)

            HStack(spacing: 4) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 11))
                    .foregroundColor(.fashionRose)
                Text("\(look.votes)")
                    .font(.runwayCaption())
                    .foregroundColor(.fashionChampagne.opacity(0.5))
            }
        }
    }
}

struct ProfileMenuItem: View {
    let icon: String
    let title: String

    var body: some View {
        Button(action: {
            HapticFeedback.light()
        }) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.fashionGold)
                    .frame(width: 32)

                Text(title)
                    .font(.runwayBody(size: 16, weight: .medium))
                    .foregroundColor(.fashionChampagne)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.fashionChampagne.opacity(0.3))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color.runwayCharcoal)
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.fashionGold.opacity(0.1), lineWidth: 1)
            )
        }
    }
}

struct DeleteAccountSection: View {
    @State private var showConfirmation = false
    @State private var isDeleting = false
    @State private var errorMessage: String?
    @State private var showError = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Conta")
                .font(.runwayTitle(size: 18))
                .foregroundColor(.fashionChampagne)

            Button(action: { showConfirmation = true }) {
                HStack(spacing: 14) {
                    Image(systemName: "trash.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.fashionRose)
                        .frame(width: 32)

                    Text("Excluir Conta")
                        .font(.runwayBody(size: 16, weight: .medium))
                        .foregroundColor(.fashionRose)

                    Spacer()

                    if isDeleting {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .fashionRose))
                    } else {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.fashionChampagne.opacity(0.3))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .background(Color.runwayCharcoal)
                .cornerRadius(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.fashionRose.opacity(0.2), lineWidth: 1)
                )
            }
            .disabled(isDeleting)
        }
        .alert("Excluir Conta", isPresented: $showConfirmation) {
            Button("Cancelar", role: .cancel) {}
            Button("Excluir", role: .destructive) {
                performDelete()
            }
        } message: {
            Text("Esta ação é irreversível. Todos os seus dados serão permanentemente removidos.")
        }
        .alert("Erro", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "Não foi possível excluir a conta.")
        }
    }

    private func performDelete() {
        isDeleting = true
        Task {
            do {
                try await APIService.shared.deleteAccount()
                await APIService.shared.clearAuth()
                await MainActor.run {
                    isDeleting = false
                    UserDefaults.standard.removeObject(forKey: "hasSeenOnboarding")
                }
            } catch {
                await MainActor.run {
                    isDeleting = false
                    errorMessage = error.localizedDescription
                    showError = true
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
