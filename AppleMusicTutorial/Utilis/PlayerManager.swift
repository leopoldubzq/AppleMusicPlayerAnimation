import SwiftUI

@Observable
final class PlayerManager {
    var isPlaying: Bool = false
    var isExpanded: Bool = false
    var playerItem: PlayerItem = .mock
    var dragOffset: CGFloat = .zero
}
