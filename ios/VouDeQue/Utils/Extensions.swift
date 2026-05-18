import SwiftUI

// MARK: - Color Palette

extension Color {
    // Backgrounds
    static let runwayBlack = Color(hex: "0A0A0F")
    static let runwayCharcoal = Color(hex: "14141B")
    static let runwayGraphite = Color(hex: "1E1E28")
    static let runwayWarm = Color(hex: "1A1512")

    // Accents — Fashion Gold & Rosê
    static let fashionGold = Color(hex: "D4AF37")
    static let fashionGoldSoft = Color(hex: "E8D08A")
    static let fashionRose = Color(hex: "E8B4B8")
    static let fashionChampagne = Color(hex: "F5F0E8")

    // Gradients
    static let goldGradient = LinearGradient(
        colors: [fashionGold, fashionRose],
        startPoint: .leading,
        endPoint: .trailing
    )
    static let darkGradient = LinearGradient(
        colors: [runwayCharcoal, runwayWarm],
        startPoint: .top,
        endPoint: .bottom
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

// MARK: - Typography

extension Font {
    static func runwayDisplay(size: CGFloat = 34, weight: Font.Weight = .medium) -> Font {
        .system(size: size, weight: weight, design: .serif)
    }

    static func runwayTitle(size: CGFloat = 22, weight: Font.Weight = .semibold) -> Font {
        .system(size: size, weight: weight, design: .default)
    }

    static func runwayBody(size: CGFloat = 16, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .default)
    }

    static func runwayCaption(size: CGFloat = 12, weight: Font.Weight = .medium) -> Font {
        .system(size: size, weight: weight, design: .default)
    }
}

// MARK: - View Modifiers

struct RunwayCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.runwayCharcoal)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.fashionGold.opacity(0.15), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)
    }
}

struct RunwayButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.fashionChampagne)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.goldGradient)
            .cornerRadius(14)
    }
}

struct RunwayTagModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.runwayCaption())
            .foregroundColor(.fashionGold)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.fashionGold.opacity(0.12))
            .cornerRadius(8)
    }
}

struct RunwayTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color.runwayGraphite)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.fashionGold.opacity(0.2), lineWidth: 1)
            )
    }
}

struct PressAnimationModifier: ViewModifier {
    @State private var isPressed = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in isPressed = true }
                    .onEnded { _ in isPressed = false }
            )
    }
}

extension View {
    func runwayCard() -> some View {
        modifier(RunwayCardModifier())
    }

    func runwayButton() -> some View {
        modifier(RunwayButtonModifier())
    }

    func runwayTag() -> some View {
        modifier(RunwayTagModifier())
    }

    func runwayTextField() -> some View {
        modifier(RunwayTextFieldModifier())
    }

    func pressAnimation() -> some View {
        modifier(PressAnimationModifier())
    }
}

// MARK: - Shimmer Effect

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        colors: [
                            .clear,
                            .white.opacity(0.15),
                            .clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geo.size.width * 2)
                    .offset(x: -geo.size.width + phase * geo.size.width * 2)
                }
                .mask(content)
            )
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}

// MARK: - Haptics

enum HapticFeedback {
    static func light() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    static func medium() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

    static func heavy() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }

    static func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    static func error() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
}

// MARK: - Date Helpers

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

// MARK: - Legacy Compatibility Aliases

extension Color {
    static let vdqBackground = runwayBlack
    static let vdqSurface = runwayCharcoal
    static let vdqSurfaceLight = runwayGraphite
    static let vdqPurple = fashionGold
    static let vdqPink = fashionRose
    static let vdqAccent = goldGradient
}

extension View {
    func vdqCardStyle() -> some View {
        runwayCard()
    }
}

// MARK: - Color Name Mapping

func colorForName(_ name: String) -> Color {
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
