import SwiftUI

struct LookResultView: View {
    let look: Look
    @State private var isSaved = false
    @State private var showShareSheet = false

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Folio
                HStack {
                    Text("← Capa")
                        .font(.vdqMono(11))
                        .foregroundColor(.vdqAsh2)
                    Spacer()
                    Text("EDITORIAL · N.º 048")
                        .font(.vdqMono(11))
                        .foregroundColor(.vdqAsh2)
                    Spacer()
                    Text("↗")
                        .font(.vdqMono(11))
                        .foregroundColor(.vdqAsh2)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 20)

                // Hero
                ZStack(alignment: .bottomLeading) {
                    Rectangle()
                        .fill(Color.vdqInk)
                        .aspectRatio(4/5, contentMode: .fit)

                    if let imageURL = look.imageURL, let url = URL(string: imageURL) {
                        AsyncImageView(url: url)
                            .aspectRatio(4/5, contentMode: .fit)
                    } else {
                        VStack(spacing: 8) {
                            Text("LOOK")
                                .font(.vdqMono(11))
                                .foregroundColor(.vdqAsh2)
                            Text(look.occasion)
                                .font(.vdqSerif(14, italic: true))
                                .foregroundColor(.vdqAsh2)
                        }
                    }

                    // Headline overlay
                    Text(look.description.prefix(look.description.firstIndex(of: ".")?.utf16Offset(in: look.description) ?? look.description.count) + ".")
                        .font(.vdqDisplay(28, italic: true))
                        .foregroundColor(.vdqBone)
                        .lineLimit(3)
                        .padding(20)
                        .background(
                            LinearGradient(
                                colors: [.vdqInk.opacity(0.0), .vdqInk.opacity(0.85)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 28)

                // Body with drop cap
                VStack(alignment: .leading, spacing: 16) {
                    let firstChar = String(look.description.prefix(1))
                    let restText = String(look.description.dropFirst())

                    HStack(alignment: .top, spacing: 4) {
                        Text(firstChar)
                            .font(.vdqDisplay(76))
                            .foregroundColor(.vdqAccent)
                            .frame(height: 56, alignment: .top)
                            .padding(.top, -4)

                        Text(restText)
                            .font(.vdqSans(16))
                            .foregroundColor(.vdqInk)
                            .lineSpacing(6)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 28)

                // Credits panel
                VStack(alignment: .leading, spacing: 0) {
                    Text("CREDITS")
                        .vdqEyebrow()
                        .padding(.horizontal, 20)
                        .padding(.bottom, 12)

                    Rectangle()
                        .fill(Color.vdqRule)
                        .frame(height: 1 / UIScreen.main.scale)
                        .padding(.horizontal, 20)

                    ForEach(look.items) { item in
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(item.category.uppercased()) — \(item.name), \(item.color)")
                                .font(.vdqSans(14, weight: .medium))
                                .foregroundColor(.vdqInk)
                            Text(item.reason)
                                .font(.vdqMono(11))
                                .foregroundColor(.vdqAsh)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)

                        Rectangle()
                            .fill(Color.vdqRule)
                            .frame(height: 1 / UIScreen.main.scale)
                            .padding(.horizontal, 20)
                    }
                }
                .padding(.bottom, 28)

                // Action Buttons
                HStack(spacing: 12) {
                    Button(action: {
                        HapticFeedback.light()
                        isSaved.toggle()
                    }) {
                        Text("Outro")
                            .font(.vdqSerif(16, italic: true))
                            .foregroundColor(.vdqInk)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .overlay(
                                Rectangle()
                                    .stroke(Color.vdqInk, lineWidth: 1)
                            )
                    }
                    .pressAnimation()

                    Button(action: {
                        HapticFeedback.medium()
                        showShareSheet = true
                    }) {
                        Text(isSaved ? "Salvo" : "Guardar no arquivo")
                            .font(.vdqSerif(16, italic: true))
                            .foregroundColor(.vdqBone)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.vdqInk)
                    }
                    .pressAnimation()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .background(Color.vdqBone.ignoresSafeArea())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: [shareText])
        }
    }

    private var shareText: String {
        var text = "Look criado no VouDeQue\n\n"
        text += "Ocasião: \(look.occasion)\n"
        text += "\(look.description)\n\n"
        text += "Pecas:\n"
        for item in look.items {
            text += "- \(item.name) — \(item.color)\n"
        }
        return text
    }
}

#Preview {
    NavigationStack {
        LookResultView(look: .sample)
    }
}
