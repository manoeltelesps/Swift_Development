import SwiftUI

struct FavoriteButton: View {
    
    let isFavorite: Bool
    let didToggleFavorite: () -> Void
    
    var favoriteIcon: String {
        isFavorite ? "heart.fill" : "heart"
    }
    
    var body: some View {
        Button {
            didToggleFavorite()
        } label: {
            Image(systemName: favoriteIcon)
                .font(.title)
                .animation(.spring, value: isFavorite)
                .phaseAnimator([true, false], trigger: isFavorite) { content, phase in
                    content.scaleEffect(phase ? 1 : 1.3)
                } animation: { phase in
                    .bouncy
                }
        }
    }
}
