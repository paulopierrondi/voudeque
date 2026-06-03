import SwiftUI

struct ProfileView: View {
    @State private var stats = UserStats.sample

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                // Header
                HStack {
                    Spacer()
                    Button(action: {
                        HapticFeedback.light()
                    }) {
                        Image(systemName: "gearshape")
                            .font(.system(size: 20))
                            .foregroundColor(.vdqAsh)
                    }
                }
                .padding(.horizontal, 20)

                // Avatar & Name
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.vdqLinen)
                            .frame(width: 88, height: 88)

                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 36, height: 36)
                            .foregroundColor(.vdqAsh)
                    }

                    Text("Maria Silva")
                        .font(.vdqDisplay(24))
                        .foregroundColor(.vdqInk)

                    Text("@mariasilva")
                        .font(.vdqMono(12))
                        .foregroundColor(.vdqAsh)
                }

                // Simplified Stats
                HStack(spacing: 0) {
                    VStack(spacing: 4) {
                        Text("\(stats.looksGenerated)")
                            .font(.vdqSans(20, weight: .semibold))
                            .foregroundColor(.vdqInk)
                        Text("Looks")
                            .font(.vdqMono(10))
                            .foregroundColor(.vdqAsh)
                    }
                    .frame(maxWidth: .infinity)

                    Rectangle()
                        .fill(Color.vdqRule)
                        .frame(width: 1)

                    VStack(spacing: 4) {
                        Text("\(stats.votesReceived)")
                            .font(.vdqSans(20, weight: .semibold))
                            .foregroundColor(.vdqInk)
                        Text("Votos")
                            .font(.vdqMono(10))
                            .foregroundColor(.vdqAsh)
                    }
                    .frame(maxWidth: .infinity)

                    Rectangle()
                        .fill(Color.vdqRule)
                        .frame(width: 1)

                    VStack(spacing: 4) {
                        Text("#\(stats.currentRank)")
                            .font(.vdqSans(20, weight: .semibold))
                            .foregroundColor(.vdqInk)
                        Text("Ranking")
                            .font(.vdqMono(10))
                            .foregroundColor(.vdqAsh)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.vertical, 16)
                .overlay(
                    Rectangle()
                        .stroke(Color.vdqRule, lineWidth: 1)
                )
                .padding(.horizontal, 20)

                // Recent Looks Section
                VStack(alignment: .leading, spacing: 14) {
                    Text("Looks Recentes")
                        .font(.vdqSerif(18, italic: true))
                        .foregroundColor(.vdqInk)
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
                VStack(spacing: 0) {
                    ProfileMenuItem(icon: "bookmark", title: "Looks Salvos")
                    ProfileMenuItem(icon: "flame", title: "Meus Desafios")
                    ProfileMenuItem(icon: "arrow.up.heart", title: "Looks Enviados")
                    ProfileMenuItem(icon: "bell", title: "Notificacoes")
                    ProfileMenuItem(icon: "questionmark.circle", title: "Ajuda")
                }
                .padding(.horizontal, 20)
                .overlay(
                    Rectangle()
                        .stroke(Color.vdqRule, lineWidth: 1)
                )
                .padding(.horizontal, 20)

                // Account Deletion
                DeleteAccountSection()
                    .padding(.horizontal, 20)

                Spacer(minLength: 30)
            }
            .padding(.top, 16)
        }
        .background(Color.vdqBone.ignoresSafeArea())
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
                    .font(.system(size: 18))
                    .foregroundColor(.vdqAsh)
                    .frame(width: 28)

                Text(title)
                    .font(.vdqSans(15, weight: .medium))
                    .foregroundColor(.vdqInk2)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.vdqAsh2)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .vdqHairline(edge: .bottom)
        }
    }
}

struct RecentLookCard: View {
    let look: Look

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                Rectangle()
                    .fill(Color.vdqLinen)
                    .frame(width: 140, height: 160)

                if let imageURL = look.imageURL, let url = URL(string: imageURL) {
                    AsyncImageView(url: url)
                        .frame(width: 140, height: 160)
                } else {
                    Text("LOOK")
                        .font(.vdqMono(10))
                        .foregroundColor(.vdqAsh2)
                }
            }

            Text(look.occasion)
                .font(.vdqSans(13, weight: .medium))
                .foregroundColor(.vdqInk)

            HStack(spacing: 4) {
                Text("\(look.votes)")
                    .font(.vdqMono(10))
                    .foregroundColor(.vdqAsh)
            }
        }
    }
}

struct DeleteAccountSection: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var showConfirmation = false
    @State private var isDeleting = false
    @State private var errorMessage: String?
    @State private var showError = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Conta")
                .font(.vdqSerif(18, italic: true))
                .foregroundColor(.vdqInk)

            Button(action: { showConfirmation = true }) {
                HStack(spacing: 14) {
                    Image(systemName: "trash")
                        .font(.system(size: 18))
                        .foregroundColor(.vdqAccent)
                        .frame(width: 28)

                    Text("Excluir Conta")
                        .font(.vdqSans(15, weight: .medium))
                        .foregroundColor(.vdqAccent)

                    Spacer()

                    if isDeleting {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .vdqAccent))
                    } else {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.vdqAsh2)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .overlay(
                    Rectangle()
                        .stroke(Color.vdqAccent.opacity(0.3), lineWidth: 1)
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
            Text("Esta acao e irreversivel. Todos os seus dados serao permanentemente removidos.")
        }
        .alert("Erro", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "Nao foi possivel excluir a conta.")
        }
    }

    private func performDelete() {
        isDeleting = true
        Task {
            do {
                try await APIService.shared.deleteAccount()
                APIService.shared.clearAuth()
                await MainActor.run {
                    isDeleting = false
                    hasSeenOnboarding = false
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
