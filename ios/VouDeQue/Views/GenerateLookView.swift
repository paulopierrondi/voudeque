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
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    Text("Conte-nos sobre o momento e deixe a IA criar")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
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
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        } else {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.vdqSurface)
                                .frame(height: 260)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white.opacity(0.08), style: StrokeStyle(lineWidth: 2, dash: [8, 6]))
                                )
                                .overlay(
                                    VStack(spacing: 12) {
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 40))
                                            .foregroundStyle(Color.vdqPurple)
                                        Text("Toque para adicionar foto")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundColor(.gray)
                                        Text("Opcional — você pode gerar sem foto")
                                            .font(.system(size: 12))
                                            .foregroundColor(.gray.opacity(0.7))
                                    }
                                )
                        }
                    }
                    .onChange(of: selectedPhoto) { _, newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                selectedImage = Image(uiImage: uiImage)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)

                // Occasion Selector
                VStack(alignment: .leading, spacing: 12) {
                    Text("Ocasião")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(occasions, id: \.self) { occasion in
                                Button(action: {
                                    withAnimation(.spring(response: 0.3)) {
                                        selectedOccasion = occasion
                                    }
                                }) {
                                    Text(occasion)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(selectedOccasion == occasion ? .white : .gray)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 12)
                                        .background(
                                            selectedOccasion == occasion
                                                ? AnyView(
                                                    LinearGradient(
                                                        colors: [Color.vdqPurple, Color.vdqPink],
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                )
                                                : AnyView(Color.vdqSurface)
                                        )
                                        .cornerRadius(16)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }

                // Style Notes
                VStack(alignment: .leading, spacing: 12) {
                    Text("Notas de Estilo (opcional)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)

                    TextEditor(text: $styleNotes)
                        .font(.system(size: 15))
                        .foregroundColor(.white)
                        .scrollContentBackground(.hidden)
                        .background(Color.vdqSurface)
                        .cornerRadius(16)
                        .frame(height: 100)
                        .padding(.horizontal, 20)
                        .overlay(
                            Group {
                                if styleNotes.isEmpty {
                                    Text("Ex: Prefiro tons neutros, quero algo confortável...")
                                        .font(.system(size: 15))
                                        .foregroundColor(.gray.opacity(0.6))
                                        .padding(.horizontal, 32)
                                        .padding(.vertical, 12)
                                        .allowsHitTesting(false)
                                }
                            },
                            alignment: .topLeading
                        )
                }

                // Generate Button
                Button(action: {
                    Task {
                        isGenerating = true
                        do {
                            generatedLook = try await APIService.shared.generateLook(
                                occasion: selectedOccasion,
                                notes: styleNotes
                            )
                            showResult = true
                        } catch {
                            print("Error: \(error)")
                        }
                        isGenerating = false
                    }
                }) {
                    HStack(spacing: 10) {
                        if isGenerating {
                            ProgressView()
                                .tint(.white)
                                .scaleEffect(1.1)
                        } else {
                            Image(systemName: "sparkles")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        Text(isGenerating ? "Criando look..." : "Gerar Look")
                            .font(.system(size: 17, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        LinearGradient(
                            colors: [Color.vdqPurple, Color.vdqPink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(20)
                    .opacity(isGenerating ? 0.8 : 1)
                }
                .disabled(isGenerating)
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .padding(.top, 16)
        }
        .background(Color.vdqBackground.ignoresSafeArea())
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
