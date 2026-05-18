import SwiftUI

extension Color {
    static let vdqBackground = Color(hex: "0A0A0F")
    static let vdqSurface = Color(hex: "14141B")
    static let vdqSurfaceLight = Color(hex: "1E1E28")
    static let vdqPurple = Color(hex: "A855F7")
    static let vdqPink = Color(hex: "EC4899")
    static let vdqAccent = LinearGradient(
        colors: [Color.vdqPurple, Color.vdqPink],
        startPoint: .leading,
        endPoint: .trailing
    )

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension View {
    func vdqCardStyle() -> some View {
        self
            .background(Color.vdqSurface)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.06), lineWidth: 1)
            )
    }
}

extension Date {
    func timeRemainingString(to endDate: Date) -> String {
        let interval = endDate.timeIntervalSince(self)
        guard interval > 0 else { return "00:00:00" }
        let hours = Int(interval) / 3600
        let minutes = Int(interval) / 60 % 60
        let seconds = Int(interval) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
