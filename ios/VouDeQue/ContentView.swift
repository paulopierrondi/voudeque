import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        Group {
            switch selectedTab {
            case 0:
                NavigationStack { HomeView().toolbarBackground(Color.vdqBone, for: .navigationBar) }
            case 1:
                NavigationStack { GenerateLookView().toolbarBackground(Color.vdqBone, for: .navigationBar) }
            case 2:
                NavigationStack { FeedView().toolbarBackground(Color.vdqBone, for: .navigationBar) }
            case 3:
                NavigationStack { ProfileView().toolbarBackground(Color.vdqBone, for: .navigationBar) }
            default:
                NavigationStack { HomeView().toolbarBackground(Color.vdqBone, for: .navigationBar) }
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.vdqRule)
                    .frame(height: 1 / UIScreen.main.scale)

                HStack(spacing: 0) {
                    tabButton(index: 0, label: "Capa", systemImage: "house")
                    tabButton(index: 1, label: "Briefing", systemImage: "camera")
                    tabButton(index: 2, label: "Em pauta", systemImage: "heart")
                    tabButton(index: 3, label: "Arquivo", systemImage: "archivebox")
                }
                .padding(.horizontal, 8)
                .padding(.top, 10)
                .padding(.bottom, 12)
                .background(Color.vdqBone)
            }
        }
    }

    private func tabButton(index: Int, label: String, systemImage: String) -> some View {
        Button(action: {
            selectedTab = index
            HapticFeedback.light()
        }) {
            VStack(spacing: 4) {
                Image(systemName: systemImage)
                    .font(.system(size: 20, weight: .regular))
                Text(label)
                    .font(.vdqMono(10))
                    .textCase(.uppercase)
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(selectedTab == index ? .vdqInk : .vdqAsh)
            .overlay(
                Rectangle()
                    .fill(Color.vdqInk)
                    .frame(height: 1.5)
                    .offset(y: -10)
                    .opacity(selectedTab == index ? 1 : 0),
                alignment: .top
            )
        }
    }
}

#Preview {
    ContentView()
}
