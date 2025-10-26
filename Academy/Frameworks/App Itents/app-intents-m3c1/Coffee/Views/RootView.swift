import SwiftUI

struct RootView: View {
    
    @Environment(Model.self) var model
    
    var body: some View {
        @Bindable var bindableModel = model
        
        TabView(selection: $bindableModel.selectedTab) {
            Tab("Menu", systemImage: "menucard", value: .menu) {
                NavigationStack {
                    MenuView()
                }
            }
            
            Tab("Favorites", systemImage: "heart", value: .favorites) {
                NavigationStack {
                    FavoritesView()
                }
            }
            
            Tab("Orders", systemImage: "receipt", value: .orders) {
                NavigationStack {
                    OrdersView()
                }
            }
            
            Tab("Bag", systemImage: "basket", value: .bag) {
                NavigationStack {
                    BagView()
                }
            }
            .badge(model.bag.items.count)
        }
    }
}
