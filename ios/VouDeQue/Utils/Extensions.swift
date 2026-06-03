import SwiftUI

// MARK: - Color Palette (Edição Cereja 2026)

extension Color {
    static let vdqAccent  = Color(hex: "#D1392E")
    static let vdqBone    = Color(hex: "#F8F4EC")
    static let vdqPaper   = Color(hex: "#F1ECDF")
    static let vdqLinen   = Color(hex: "#E9E2D1")
    static let vdqInk     = Color(hex: "#1A1714")
    static let vdqInk2    = Color(hex: "#2B2622")
    static let vdqAsh     = Color(hex: "#6B655B")
    static let vdqAsh2    = Color(hex: "#A39C8F")
    static let vdqRule    = Color.vdqInk.opacity(0.16)

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
    static func vdqMasthead(_ size: CGFloat) -> Font {
        Font.custom("BodoniModa-VariableFont_opsz,wght", size: size)
    }

    static func vdqDisplay(_ size: CGFloat, italic: Bool = false) -> Font {
        Font.custom(italic ? "BodoniModa-Italic-VariableFont_opsz,wght" : "BodoniModa-VariableFont_opsz,wght", size: size)
    }

    static func vdqSerif(_ size: CGFloat, italic: Bool = false) -> Font {
        Font.custom(italic ? "InstrumentSerif-Italic" : "InstrumentSerif-Regular", size: size)
    }

    static func vdqSans(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        Font.custom("Geist-VariableFont_wght", size: size).weight(weight)
    }

    static func vdqMono(_ size: CGFloat) -> Font {
        Font.custom("GeistMono-VariableFont_wght", size: size)
    }
}

// MARK: - View Modifiers

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

struct VdqEyebrowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.vdqMono(11))
            .kerning(2.4)
            .textCase(.uppercase)
            .foregroundColor(.vdqAsh)
    }
}

struct VdqHairlineModifier: ViewModifier {
    let edge: Edge

    func body(content: Content) -> some View {
        content
            .overlay(
                Rectangle()
                    .fill(Color.vdqRule)
                    .frame(height: 1 / UIScreen.main.scale)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: edge == .top ? .top : .bottom),
                alignment: edge == .top ? .top : .bottom
            )
    }
}

extension View {
    func pressAnimation() -> some View {
        modifier(PressAnimationModifier())
    }

    func vdqEyebrow() -> some View {
        modifier(VdqEyebrowModifier())
    }

    func vdqHairline(edge: Edge = .bottom) -> some View {
        modifier(VdqHairlineModifier(edge: edge))
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

@MainActor
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
    case "bege", "marrom", "camelo": return Color(hex: "#C4A484")
    case "prata", "dourado": return Color(hex: "#C0C0C0")
    default: return .gray
    }
}
