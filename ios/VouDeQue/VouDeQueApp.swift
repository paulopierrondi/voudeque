import SwiftUI

@main
struct VouDeQueApp: App {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    init() {
        if ProcessInfo.processInfo.arguments.contains("--uitest-reset") {
            UserDefaults.standard.removeObject(forKey: "hasSeenOnboarding")
        }
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.vdqBone)
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(Color.vdqInk),
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(Color.vdqInk),
            .font: UIFont.systemFont(ofSize: 34, weight: .medium)
        ]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = UIColor(Color.vdqInk)
    }

    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                ContentView()
            } else {
                OnboardingView()
            }
        }
    }
}
