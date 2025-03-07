import SwiftUI

struct MiniPlayerView: View {
    
    @Environment(PlayerManager.self) private var playerManager
    let animation: Namespace.ID
    
    var body: some View {
        HStack {
            ZStack {
                if playerManager.isExpanded == false {
                    Image(.artwork)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .matchedGeometryEffect(
                            id: "artwork",
                            in: animation,
                            isSource: true
                        )
                }
            }
            .frame(width: 35, height: 35)
            
            Group {
                Text("Recess")
                    .fontWeight(.semibold)
                Spacer()
                Group {
                    HStack(spacing: 16) {
                        Button { playerManager.isPlaying.toggle() } label: {
                            Image(systemName: playerManager.isPlaying ? "pause.fill" : "play.fill")
                                .contentTransition(.symbolEffect(.replace))
                        }
                        
                        Button {} label: {
                            Image(systemName: "forward.fill")
                        }
                    }
                }
                .font(.title3)
                .tint(.primary)
            }
            .opacity(playerManager.isExpanded ? 0 : 1)
            .transaction { transaction in
                transaction.animation = nil
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: Constants.miniPlayerHeight)
        .padding(.horizontal, 24)
        .contentShape(.rect)
        .onTapGesture {
            withAnimation(.snappy(duration: 0.3, extraBounce: 0.04)) {
                playerManager.isExpanded = true
            }
        }
    }
}

#Preview {
    
    @Previewable @Namespace var animation
    
    MiniPlayerView(animation: animation)
        .environment(PlayerManager())
}
