import SwiftUI

struct ExpandedPlayerView: View {
    
    let animation: Namespace.ID
    
    @Environment(PlayerManager.self) private var playerManager
    @State private var playerContentOffsetY: CGFloat = 400
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            VStack {
                Spacer()
                
                ZStack {
                    if playerManager.isExpanded {
                        Image(playerManager.playerItem.artwork)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(.rect(cornerRadius: 12))
                            .scaleEffect(playerManager.isPlaying ? 1 : 0.9)
                            .matchedGeometryEffect(
                                id: "artwork",
                                in: animation
                            )
                            .transition(.offset(y: 1)) // for smooth animation transition
                            .animation(.smooth(duration: 0.4), value: playerManager.isPlaying)
                    }
                        
                }
                .frame(width: size.width * 0.7, height: size.width * 0.7)
                
                Spacer()
                
                VStack {
                    PlayerSongInfoView(playerManager.playerItem)
                    PlayerSliderView(playerManager.playerItem)
                    PlayerControlsView(playerManager.playerItem)
                }
                .offset(y: playerContentOffsetY)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.top, safeArea.top)
            .padding(.bottom, safeArea.bottom)
            .contentShape(.rect)
            .offset(y: playerManager.dragOffset)
            .gesture(
                DragGesture(minimumDistance: 1)
                    .onChanged({ value in
                        guard playerManager.isExpanded else { return }
                        playerManager.dragOffset = max(0, value.translation.height)
                    })
                    .onEnded({ value in
                        guard playerManager.isExpanded else { return }
                        let translation = value.translation
                        let playerShouldCollapse = translation.height > size.height / 6
                        withAnimation(.snappy(duration: 0.35, extraBounce: 0.04)) {
                            playerManager.isExpanded = playerShouldCollapse == false
                            playerContentOffsetY = playerShouldCollapse == false ? 0 : 400
                            playerManager.dragOffset = .zero
                        }
                    })
            )
        }
        .onAppear {
            withAnimation(.snappy(duration: 0.3, extraBounce: 0.04)) {
                playerContentOffsetY = .zero
            }
        }
    }
    
    private func PlayerSongInfoView(_ playerItem: PlayerItem) -> some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(playerItem.song)
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.primary)
                Text(playerItem.artist)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button {} label: {
                Image(systemName: "ellipsis")
                    .frame(width: 32, height: 32)
                    .background(.ultraThickMaterial, in: .circle)
            }
            .tint(.primary)
        }
        .padding(.horizontal, 24)
    }
    
    private func PlayerSliderView(_ playerItem: PlayerItem) -> some View {
        GeometryReader {
            let size = $0.size
            Capsule()
                .frame(height: size.height)
                .foregroundStyle(.secondary.opacity(0.2))
                .overlay(alignment: .leading) {
                    Capsule()
                        .fill(.secondary)
                        .frame(
                            width: size.width * 0.6,
                            height: size.height
                        )
                }
                .padding(.horizontal, 24)
        }
        .frame(height: 8)
        .padding(.vertical)
    }
    
    private func PlayerControlsView(_ playerItem: PlayerItem) -> some View {
        HStack(spacing: 60) {
            Button {} label: {
                Image(systemName: "forward.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .rotationEffect(.degrees(180))
            }
            
            Button { playerManager.isPlaying.toggle() } label: {
                Image(systemName: playerManager.isPlaying ? "pause.fill" : "play.fill")
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(2.5)
                    .contentTransition(.symbolEffect(.replace))
            }
            .frame(width: 40, height: 40)
            .animation(.smooth(duration: 0.4), value: playerManager.isPlaying)
            
            Button {} label: {
                Image(systemName: "forward.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
            }
        }
        .tint(.primary)
        .padding(.vertical, 40)
    }
}

#Preview {
    @Previewable @State var playerManager = PlayerManager()
    
    @Previewable @Namespace var animation
    
    ExpandedPlayerView(animation: animation)
        .onAppear {
            playerManager.isExpanded = true
        }
        .environment(playerManager)
}
