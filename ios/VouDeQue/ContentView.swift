import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Início")
            }
            .tag(0)

            NavigationStack {
                GenerateLookView()
            }
            .tabItem {
                Image(systemName: "sparkles")
                Text("Gerar")
            }
            .tag(1)

            NavigationStack {
                ChallengesView()
            }
            .tabItem {
                Image(systemName: "flame.fill")
                Text("Desafios")
            }
            .tag(2)

            NavigationStack {
                FeedView()
            }
            .tabItem {
                Image(systemName: "heart.fill")
                Text("Feed")
            }
            .tag(3)

            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Perfil")
            }
            .tag(4)
        }
        .tint(Color.vdqPurple)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(Color(hex: "14141B"))
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.vdqPurple)
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(Color.vdqPurple)]
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    ContentView()
}
