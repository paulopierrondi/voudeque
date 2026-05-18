import SwiftUI

struct ShimmerLoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ForEach(0..<3) { _ in
                ShimmerCard()
            }
        }
        .padding(.horizontal, 20)
    }
}

struct ShimmerCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.runwayGraphite)
                    .frame(width: 40, height: 40)

                VStack(alignment: .leading, spacing: 6) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.runwayGraphite)
                        .frame(width: 120, height: 14)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.runwayGraphite)
                        .frame(width: 80, height: 12)
                }

                Spacer()
            }

            RoundedRectangle(cornerRadius: 12)
                .fill(Color.runwayGraphite)
                .frame(height: 220)

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.runwayGraphite)
                .frame(height: 14)

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.runwayGraphite)
                .frame(width: 200, height: 12)
        }
        .padding(16)
        .background(Color.runwayCharcoal)
        .cornerRadius(16)
        .shimmer()
    }
}

struct ShimmerStatsView: View {
    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<3) { _ in
                VStack(spacing: 8) {
                    Circle()
                        .fill(Color.runwayGraphite)
                        .frame(width: 28, height: 28)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.runwayGraphite)
                        .frame(width: 40, height: 16)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.runwayGraphite)
                        .frame(width: 50, height: 12)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.runwayCharcoal)
                .cornerRadius(16)
            }
        }
        .padding(.horizontal, 20)
        .shimmer()
    }
}

#Preview {
    ZStack {
        Color.runwayBlack.ignoresSafeArea()
        ShimmerLoadingView()
    }
}
