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

    let occasions = ["Casual", "Trabalho", "Date", "Festa", "Academia"]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 4) {
                    Text("Gerar Look")
                        .font(.runwayDisplay(size: 28))
                        .foregroundColor(.fashionChampagne)
                    Text("Conte-nos sobre o momento e deixe a IA criar")
                        .font(.runwayBody(size: 15))
                        .foregroundColor(.fashionChampagne.opacity(0.6))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)

                // Photo Picker
                VStack(spacing: 12) {
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        if let selectedImage {
                            selectedImage
                                .resizable()
                                .scaledToFill()
                                .frame(height: 260)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.fashionGold.opacity(0.2), lineWidth: 1)
                                )
                        } else {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.runwayCharcoal)
                                    .frame(height: 260)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.fashionGold.opacity(0.15), style: StrokeStyle(lineWidth: 2, dash: [8, 6]))
                                    )

                                VStack(spacing: 12) {
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 40))
                                        .foregroundStyle(Color.fashionGold.opacity(0.6))
                                    Text("Toque para adicionar foto")
                                        .font(.runwayBody(size: 15, weight: .medium))
                                        .foregroundColor(.fashionChampagne.opacity(0.6))
                                    Text("Opcional — você pode gerar sem foto")
                                        .font(.runwayCaption())
                                        .foregroundColor(.fashionChampagne.opacity(0.4))
                                }
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

                // Occasion Selector
                VStack(alignment: .leading, spacing: 12) {
                    Text("Ocasião")
                        .font(.runwayTitle(size: 16))
                        .foregroundColor(.fashionChampagne)
                        .padding(.horizontal, 20)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(occasions, id: \.self) { occasion in
                                Button(action: {
                                    HapticFeedback.light()
                                    withAnimation(.spring(response: 0.3)) {
                                        selectedOccasion = occasion
                                    }
                                }) {
                                    Text(occasion)
                                        .font(.runwayBody(size: 15, weight: .semibold))
                                        .foregroundColor(selectedOccasion == occasion ? .fashionChampagne : .fashionChampagne.opacity(0.5))
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 12)
                                        .background(
                                            selectedOccasion == occasion
                                                ? AnyView(Color.goldGradient)
                                                : AnyView(Color.runwayCharcoal)
                                        )
                                        .cornerRadius(14)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14)
                                                .stroke(selectedOccasion == occasion ? Color.clear : Color.fashionGold.opacity(0.15), lineWidth: 1)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }

                // Style Notes
                VStack(alignment: .leading, spacing: 12) {
                    Text("Notas de Estilo (opcional)")
                        .font(.runwayTitle(size: 16))
                        .foregroundColor(.fashionChampagne)
                        .padding(.horizontal, 20)

                    TextEditor(text: $styleNotes)
                        .font(.runwayBody(size: 15))
                        .foregroundColor(.fashionChampagne)
                        .scrollContentBackground(.hidden)
                        .runwayTextField()
                        .frame(height: 100)
                        .padding(.horizontal, 20)
                        .overlay(
                            Group {
                                if styleNotes.isEmpty {
                                    Text("Ex: Prefiro tons neutros, quero algo confortável...")
                                        .font(.runwayBody(size: 15))
                                        .foregroundColor(.fashionChampagne.opacity(0.3))
                                        .padding(.horizontal, 36)
                                        .padding(.vertical, 14)
                                        .allowsHitTesting(false)
                                }
                            },
                            alignment: .topLeading
                        )
                }

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
                                .tint(.fashionChampagne)
                                .scaleEffect(1.1)
                        } else {
                            Image(systemName: "sparkles")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        Text(isGenerating ? "Criando look..." : "Gerar Look")
                            .font(.runwayTitle(size: 17, weight: .bold))
                    }
                    .runwayButton()
                    .opacity(isGenerating ? 0.8 : 1)
                }
                .disabled(isGenerating)
                .pressAnimation()
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .padding(.top, 16)
        }
        .background(Color.runwayBlack.ignoresSafeArea())
        .navigationDestination(isPresented: $showResult) {
            if let look = generatedLook {
                LookResultView(look: look)
            }
        }
    }
}

#Preview {
    NavigationStack {
        GenerateLookView()
    }
}
