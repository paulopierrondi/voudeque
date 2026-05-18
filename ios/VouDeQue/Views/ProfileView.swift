import SwiftUI

struct ProfileView: View {
    @State private var stats = UserStats.sample

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header with Settings
                HStack {
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 20)

                // Avatar & Name
                VStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.vdqPurple.opacity(0.3), Color.vdqPink.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)

                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)
                            .foregroundColor(.white)
                    }

                    Text("Maria Silva")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)

                    Text("@mariasilva")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }

                // Stats Grid
                HStack(spacing: 12) {
                    ProfileStatCard(
                        value: "\(stats.looksGenerated)",
                        label: "Looks",
                        icon: "sparkles.rectangle.stack",
                        gradient: [Color.vdqPurple, Color.vdqPink]
                    )
                    ProfileStatCard(
                        value: "\(stats.votesReceived)",
                        label: "Votos",
                        icon: "heart.fill",
                        gradient: [Color.pink, Color.red]
                    )
                    ProfileStatCard(
                        value: "#\(stats.currentRank)",
                        label: "Ranking",
                        icon: "trophy.fill",
                        gradient: [Color.orange, Color.yellow]
                    )
                }
                .padding(.horizontal, 20)

                // Recent Looks Section
                VStack(alignment: .leading, spacing: 14) {
                    Text("Looks Recentes")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
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
                    ProfileMenuItem(icon: "bookmark.fill", title: "Looks Salvos", color: .purple)
                    ProfileMenuItem(icon: "flame.fill", title: "Meus Desafios", color: .orange)
                    ProfileMenuItem(icon: "arrow.up.heart.fill", title: "Looks Enviados", color: .pink)
                    ProfileMenuItem(icon: "bell.fill", title: "Notificações", color: .blue)
                    ProfileMenuItem(icon: "questionmark.circle.fill", title: "Ajuda", color: .green)
                }
                .padding(.horizontal, 20)

                Spacer(minLength: 30)
            }
            .padding(.top, 16)
        }
        .background(Color.vdqBackground.ignoresSafeArea())
    }
}

struct ProfileStatCard: View {
    let value: String
    let label: String
    let icon: String
    let gradient: [Color]

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundStyle(
                    LinearGradient(
                        colors: gradient,
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .vdqCardStyle()
    }
}

struct RecentLookCard: View {
    let look: Look

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 14)
                .fill(
                    LinearGradient(
                        colors: [Color.vdqSurfaceLight, Color.vdqPurple.opacity(0.12)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 140, height: 160)
                .overlay(
                    Image(systemName: "sparkles")
                        .font(.system(size: 28))
                        .foregroundStyle(Color.vdqPurple.opacity(0.4))
                )

            Text(look.occasion)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)

            HStack(spacing: 4) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 11))
                    .foregroundColor(.pink)
                Text("\(look.votes)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
            }
        }
    }
}

struct ProfileMenuItem: View {
    let icon: String
    let title: String
    let color: Color

    var body: some View {
        Button(action: {}) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                    .frame(width: 32)

                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color.vdqSurface)
            .cornerRadius(16)
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
