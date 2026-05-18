import SwiftUI

struct LookResultView: View {
    let look: Look
    @State private var isSaved = false
    @State private var showShareSheet = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Generated Image / Placeholder
                ZStack {
                    Color.darkGradient
                        .frame(height: 360)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.fashionGold.opacity(0.15), lineWidth: 1)
                        )

                    if let imageURL = look.imageURL, let url = URL(string: imageURL) {
                        AsyncImageView(url: url)
                            .frame(height: 360)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "sparkles")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 56, height: 56)
                                .foregroundStyle(Color.fashionGold.opacity(0.5))
                            Text("Look Gerado")
                                .font(.runwayTitle(size: 20))
                                .foregroundColor(.fashionChampagne)
                            Text(look.occasion)
                                .font(.runwayCaption())
                                .foregroundColor(.fashionChampagne.opacity(0.6))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)
                                .background(Color.fashionGold.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal, 20)

                // Description
                VStack(alignment: .leading, spacing: 8) {
                    Text("Descrição")
                        .font(.runwayTitle(size: 16))
                        .foregroundColor(.fashionChampagne)
                    Text(look.description)
                        .font(.runwayBody(size: 15))
                        .foregroundColor(.fashionChampagne.opacity(0.85))
                        .lineSpacing(4)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)

                // Items List
                VStack(alignment: .leading, spacing: 12) {
                    Text("Peças do Look")
                        .font(.runwayTitle(size: 16))
                        .foregroundColor(.fashionChampagne)
                        .padding(.horizontal, 20)

                    VStack(spacing: 8) {
                        ForEach(look.items) { item in
                            HStack(spacing: 14) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(colorForName(item.color))
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.fashionGold.opacity(0.15), lineWidth: 1)
                                    )

                                VStack(alignment: .leading, spacing: 3) {
                                    Text(item.name)
                                        .font(.runwayBody(size: 15, weight: .semibold))
                                        .foregroundColor(.fashionChampagne)
                                    HStack(spacing: 6) {
                                        Text(item.category)
                                            .font(.runwayCaption())
                                            .foregroundColor(.fashionChampagne.opacity(0.5))
                                        Text("·")
                                            .foregroundColor(.fashionChampagne.opacity(0.3))
                                        Text(item.reason)
                                            .font(.runwayCaption())
                                            .foregroundColor(.fashionChampagne.opacity(0.5))
                                            .lineLimit(1)
                                    }
                                }

                                Spacer()
                            }
                            .padding(14)
                            .background(Color.runwayCharcoal)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.fashionGold.opacity(0.1), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                }

                // Action Buttons
                HStack(spacing: 12) {
                    Button(action: {
                        HapticFeedback.light()
                        isSaved.toggle()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                                .font(.system(size: 18, weight: .semibold))
                            Text(isSaved ? "Salvo" : "Salvar")
                                .font(.runwayBody(size: 16, weight: .semibold))
                        }
                        .foregroundColor(isSaved ? Color.fashionRose : .fashionChampagne)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.runwayCharcoal)
                        .cornerRadius(14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.fashionGold.opacity(0.15), lineWidth: 1)
                        )
                    }
                    .pressAnimation()

                    Button(action: {
                        HapticFeedback.medium()
                        showShareSheet = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Compartilhar")
                                .font(.runwayBody(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.fashionChampagne)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.goldGradient)
                        .cornerRadius(14)
                    }
                    .pressAnimation()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .padding(.top, 16)
        }
        .background(Color.runwayBlack.ignoresSafeArea())
        .navigationTitle("Resultado")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: [shareText])
        }
    }

    private var shareText: String {
        var text = "✨ Look criado no VouDeQue\n\n"
        text += "Ocasião: \(look.occasion)\n"
        text += "\(look.description)\n\n"
        text += "Peças:\n"
        for item in look.items {
            text += "• \(item.name) — \(item.color)\n"
        }
        return text
    }
}

#Preview {
    NavigationStack {
        LookResultView(look: .sample)
    }
}
