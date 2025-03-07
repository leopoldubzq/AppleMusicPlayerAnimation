import SwiftUI

struct MainScreen: View {
    
    @State private var selectedTab: TabBarItem = .home
    @State private var playerManager = PlayerManager()
    @Namespace private var animation
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedTab) {
                ForEach(TabBarItem.allCases, id: \.self) { tab in
                    Tab(value: tab) {
                        Text(tab.name)
                    }
                }
            }
            CustomTabBar()
        }
        .overlay(alignment: .bottom) {
            PlayerBackgroundView()
                .environment(playerManager)
        }
        .overlay(alignment: .bottom) {
            MiniPlayerView(animation: animation)
                .padding(.bottom, Constants.tabBarHeight)
                .environment(playerManager)
        }
        .overlay {
            if playerManager.isExpanded {
                ExpandedPlayerView(animation: animation)
                    .environment(playerManager)
            }
        }
    }
    
    private func CustomTabBar() -> some View {
        HStack {
            ForEach(TabBarItem.allCases, id: \.self) { tab in
                VStack(spacing: 4) {
                    Image(systemName: tab.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                    Text(tab.name)
                        .font(.caption)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundStyle(selectedTab == tab ? .accent : .secondary)
                .background(.background)
                .onTapGesture {
                    selectedTab = tab
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: Constants.tabBarHeight)
    }
}

#Preview {
    MainScreen()
}

private extension MainScreen {
    enum TabBarItem: String, CaseIterable {
        case home
        case radio
        case library
        case search
        
        var name: String {
            rawValue.capitalized
        }
        
        var icon: String {
            switch self {
            case .home:
                "house.fill"
            case .radio:
                "dot.radiowaves.left.and.right"
            case .library:
                "music.note.house"
            case .search:
                "magnifyingglass"
            }
        }
    }
}
