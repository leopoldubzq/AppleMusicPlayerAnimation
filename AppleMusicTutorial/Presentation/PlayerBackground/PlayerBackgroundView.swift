import SwiftUI

struct PlayerBackgroundView: View {
    
    @Environment(PlayerManager.self) private var playerManager
    
    var body: some View {
        GeometryReader {
            let safeArea = $0.safeAreaInsets
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThickMaterial)
                .overlay(alignment: .top) {
                    Capsule()
                        .fill(.secondary.opacity(0.3))
                        .frame(width: 50, height: 7)
                        .padding(.top, 8)
                        .padding(.top, safeArea.top)
                        .opacity(playerManager.isExpanded ? 1 : 0)
                }
                .offset(y: playerManager.dragOffset)
                .ignoresSafeArea()
        }
        .frame(
            height: playerManager.isExpanded ? nil : Constants.miniPlayerHeight,
            alignment: .bottom
        )
        .padding(.bottom, playerManager.isExpanded ? 0 : Constants.tabBarHeight)
        .padding(.horizontal, playerManager.isExpanded ? 0 : 16)
    }
}

#Preview {
    
    @Previewable @State var playerManager = PlayerManager()
    
    PlayerBackgroundView()
        .onAppear {
            playerManager.isExpanded = false
        }
        .environment(playerManager)
}
