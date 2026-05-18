import SwiftUI

struct LookResultView: View {
    let look: Look
    @State private var isSaved = false
    @State private var showShareSheet = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Generated Image
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.vdqSurfaceLight,
                                Color.vdqPurple.opacity(0.2),
                                Color.vdqPink.opacity(0.15)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 360)
                    .overlay(
                        VStack(spacing: 16) {
                            Image(systemName: "sparkles")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 56, height: 56)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color.vdqPurple, Color.vdqPink],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            Text("Look Gerado")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            Text(look.occasion)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)
                                .background(Color.white.opacity(0.06))
                                .cornerRadius(10)
                        }
                    )
                    .padding(.horizontal, 20)

                // Description
                VStack(alignment: .leading, spacing: 8) {
                    Text("Descrição")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    Text(look.description)
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.85))
                        .lineSpacing(4)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)

                // Items List
                VStack(alignment: .leading, spacing: 12) {
                    Text("Peças do Look")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)

                    VStack(spacing: 8) {
                        ForEach(look.items) { item in
                            HStack(spacing: 14) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(colorForName(item.color))
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )

                                VStack(alignment: .leading, spacing: 3) {
                                    Text(item.name)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(.white)
                                    HStack(spacing: 6) {
                                        Text(item.category)
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(.gray)
                                        Text("·")
                                            .foregroundColor(.gray)
                                        Text(item.reason)
                                            .font(.system(size: 12))
                                            .foregroundColor(.white.opacity(0.6))
                                            .lineLimit(1)
                                    }
                                }

                                Spacer()
                            }
                            .padding(14)
                            .background(Color.vdqSurface)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                }

                // Action Buttons
                HStack(spacing: 12) {
                    Button(action: {
                        isSaved.toggle()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                                .font(.system(size: 18, weight: .semibold))
                            Text(isSaved ? "Salvo" : "Salvar")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(isSaved ? Color.vdqPink : .white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.vdqSurface)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.08), lineWidth: 1)
                        )
                    }

                    Button(action: {
                        showShareSheet = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Compartilhar")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [Color.vdqPurple, Color.vdqPink],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(20)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .padding(.top, 16)
        }
        .background(Color.vdqBackground.ignoresSafeArea())
        .navigationTitle("Resultado")
        .navigationBarTitleDisplayMode(.inline)
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
    NavigationStack {
        LookResultView(look: .sample)
    }
}
