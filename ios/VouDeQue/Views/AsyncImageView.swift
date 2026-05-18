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
                Color.darkGradient
                Image(systemName: "sparkles")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
                    .foregroundStyle(Color.fashionGold.opacity(0.3))
            }
        }
    }

    private var errorView: some View {
        ZStack {
            Color.runwayCharcoal
            VStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 28))
                    .foregroundColor(.fashionRose.opacity(0.7))
                Text("Erro ao carregar")
                    .font(.runwayCaption())
                    .foregroundColor(.fashionChampagne.opacity(0.5))
            }
        }
    }
}

#Preview {
    AsyncImageView(url: URL(string: "https://example.com/image.jpg"))
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding()
}
