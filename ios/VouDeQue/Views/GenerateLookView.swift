import SwiftUI
import PhotosUI

struct GenerateLookView: View {
    @State private var selectedOccasion = "Casual"
    @State private var styleNotes = ""
    @State private var isGenerating = false
    @State private var generatedLook: Look?
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImage: Image?
    @State private var showResult = false
    @FocusState private var notesFocused: Bool

    let occasions = ["Casual", "Trabalho", "Date", "Festa", "Academia", "Viagem"]

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header
                VStack(alignment: .leading, spacing: 4) {
                    Text("O briefing de hoje.")
                        .font(.vdqDisplay(32, italic: true))
                        .foregroundColor(.vdqInk)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)

                // 01. Foto
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text("01.")
                            .font(.vdqDisplay(44, italic: true))
                            .foregroundColor(.vdqInk)
                        Text("Foto")
                            .font(.vdqSerif(17, italic: true))
                            .foregroundColor(.vdqAsh)
                            .padding(.top, 16)
                        Spacer()
                    }

                    let currentImage = selectedImage
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        if let currentImage {
                            currentImage
                                .resizable()
                                .scaledToFill()
                                .frame(height: 320)
                                .clipShape(Rectangle())
                                .overlay(
                                    Rectangle()
                                        .stroke(Color.vdqRule, lineWidth: 1)
                                )
                        } else {
                            ZStack {
                                Rectangle()
                                    .fill(Color.vdqLinen)
                                    .frame(height: 320)
                                    .overlay(
                                        Rectangle()
                                            .stroke(Color.vdqInk.opacity(0.12), style: StrokeStyle(lineWidth: 1, dash: [6, 4]))
                                    )

                                Text("+")
                                    .font(.vdqDisplay(40, italic: true))
                                    .foregroundColor(.vdqAsh2)
                            }
                        }
                    }
                    .onChange(of: selectedPhoto) { _, newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                await MainActor.run {
                                    selectedImage = Image(uiImage: uiImage)
                                    HapticFeedback.medium()
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)

                // 02. Ocasião
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text("02.")
                            .font(.vdqDisplay(44, italic: true))
                            .foregroundColor(.vdqInk)
                        Text("Ocasião")
                            .font(.vdqSerif(17, italic: true))
                            .foregroundColor(.vdqAsh)
                            .padding(.top, 16)
                        Spacer()
                    }

                    FlowLayout(spacing: 10) {
                        ForEach(occasions, id: \.self) { occasion in
                            Button(action: {
                                HapticFeedback.light()
                                withAnimation(.spring(response: 0.3)) {
                                    selectedOccasion = occasion
                                }
                            }) {
                                Text(occasion)
                                    .font(.vdqSerif(15, italic: true))
                                    .foregroundColor(selectedOccasion == occasion ? .vdqBone : .vdqInk)
                                    .padding(.horizontal, 18)
                                    .padding(.vertical, 10)
                                    .background(
                                        selectedOccasion == occasion
                                            ? AnyView(Color.vdqInk)
                                            : AnyView(Color.clear)
                                    )
                                    .overlay(
                                        Rectangle()
                                            .stroke(Color.vdqInk.opacity(selectedOccasion == occasion ? 0 : 0.2), lineWidth: 1)
                                    )
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)

                // 03. Notas
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text("03.")
                            .font(.vdqDisplay(44, italic: true))
                            .foregroundColor(.vdqInk)
                        Text("Notas")
                            .font(.vdqSerif(17, italic: true))
                            .foregroundColor(.vdqAsh)
                            .padding(.top, 16)
                        Spacer()
                    }

                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.vdqInk)
                            .frame(height: 1)

                        TextEditor(text: $styleNotes)
                            .font(.vdqSans(15))
                            .foregroundColor(.vdqInk)
                            .scrollContentBackground(.hidden)
                            .frame(height: 80)
                            .padding(.vertical, 8)
                            .focused($notesFocused)
                            .overlay(
                                Group {
                                    if styleNotes.isEmpty {
                                        Text("Ex: Prefiro tons neutros, quero algo confortavel...")
                                            .font(.vdqSans(15))
                                            .foregroundColor(.vdqAsh2)
                                            .padding(.vertical, 14)
                                            .allowsHitTesting(false)
                                    }
                                },
                                alignment: .topLeading
                            )

                        Rectangle()
                            .fill(Color.vdqInk)
                            .frame(height: 1)
                    }
                }
                .padding(.horizontal, 20)

                // Generate Button
                Button(action: {
                    HapticFeedback.medium()
                    Task {
                        isGenerating = true
                        do {
                            generatedLook = try await APIService.shared.generateLook(
                                occasion: selectedOccasion,
                                notes: styleNotes
                            )
                            HapticFeedback.success()
                            showResult = true
                        } catch {
                            HapticFeedback.error()
                            print("Error: \(error)")
                        }
                        isGenerating = false
                    }
                }) {
                    HStack(spacing: 10) {
                        if isGenerating {
                            ProgressView()
                                .tint(.vdqBone)
                                .scaleEffect(1.1)
                        }
                        Text(isGenerating ? "Criando look..." : "Fechar a edicao")
                            .font(.vdqSerif(17, italic: true))
                        if !isGenerating {
                            Text("≈ 2,8 s")
                                .font(.vdqMono(11))
                                .foregroundColor(.vdqAsh2)
                        }
                    }
                    .foregroundColor(.vdqBone)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.vdqInk)
                }
                .disabled(isGenerating)
                .accessibilityLabel(isGenerating ? "Criando look..." : "Fechar a edicao")
                .accessibilityIdentifier("generateLookButton")
                .pressAnimation()
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .padding(.top, 16)
        }
        .background(Color.vdqBone.ignoresSafeArea())
        .navigationDestination(isPresented: $showResult) {
            if let look = generatedLook {
                LookResultView(look: look)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("OK") {
                    notesFocused = false
                }
            }
        }
    }
}

// Simple flow layout for chips
struct FlowLayout: Layout {
    var spacing: CGFloat = 10

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.width ?? 0, subviews: subviews, spacing: spacing)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x,
                                      y: bounds.minY + result.positions[index].y),
                          proposal: .unspecified)
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var rowHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += rowHeight + spacing
                    rowHeight = 0
                }
                positions.append(CGPoint(x: x, y: y))
                rowHeight = max(rowHeight, size.height)
                x += size.width + spacing
            }

            self.size = CGSize(width: maxWidth, height: y + rowHeight)
        }
    }
}

#Preview {
    NavigationStack {
        GenerateLookView()
    }
}
