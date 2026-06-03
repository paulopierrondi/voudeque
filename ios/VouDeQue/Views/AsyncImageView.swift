import SwiftUI

struct AsyncImageView: View {
    let url: URL?
    var placeholder: AnyView? = nil

    var body: some View {
        if let url = url {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    placeholderView
                        .shimmer()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    errorView
                @unknown default:
                    placeholderView
                }
            }
        } else {
            placeholderView
        }
    }

    @ViewBuilder
    private var placeholderView: some View {
        if let placeholder = placeholder {
            placeholder
        } else {
            ZStack {
                Color.vdqLinen
                Text("LOOK")
                    .font(.vdqMono(10))
                    .foregroundColor(.vdqAsh2)
            }
        }
    }

    private var errorView: some View {
        ZStack {
            Color.vdqLinen
            VStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 24))
                    .foregroundColor(.vdqAccent.opacity(0.7))
                Text("Erro ao carregar")
                    .font(.vdqMono(10))
                    .foregroundColor(.vdqAsh)
            }
        }
    }
}

#Preview {
    AsyncImageView(url: URL(string: "https://example.com/image.jpg"))
        .frame(height: 200)
        .clipShape(Rectangle())
        .padding()
}
