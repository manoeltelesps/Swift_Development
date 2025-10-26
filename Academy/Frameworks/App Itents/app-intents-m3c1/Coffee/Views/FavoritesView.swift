import SwiftUI

struct FavoritesView: View {
    
    @Environment(Model.self) var model
    
    var body: some View {
        List {
            ForEach(model.favorites) { item in
                MenuItemCard(
                    item: item,
                    isFavorite: model.isFavorite(item: item),
                    didAddToBag: {
                        model.bag.add(item)
                    },
                    didToggleFavorite: {
                        model.toogleFavorite(for: item)
                    }
                )
            }
            .animation(.default, value: model.favorites)
            .listRowInsets(.init(8))
            .listRowBackground(EmptyView())
        }
        .listRowSpacing(.listRowSpacing)
        .navigationTitle("Favorites")
        .overlay { emptyState }
    }
    
    @ViewBuilder
    var emptyState: some View {
        if model.favorites.isEmpty {
            ContentUnavailableView(
                "Your list is empty",
                systemImage: "heart",
                description: Text("Favorite items from the menu")
            )
        }
    }
}

#Preview {
    NavigationStack {
        FavoritesView()
            .environment(Model())
    }
}
