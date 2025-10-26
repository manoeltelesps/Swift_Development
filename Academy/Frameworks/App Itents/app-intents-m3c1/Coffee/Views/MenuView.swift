import SwiftUI

struct MenuView: View {
    
    @Environment(Model.self) var model
    
    var body: some View {
        ScrollView {
            MenuItemCarousel(
                title: "Drinks",
                items: model.drinks
            )
            
            MenuItemCarousel(
                title: "Foods",
                items: model.foods
            )
        }
        .background(.listBackground)
        .navigationTitle("Menu")
    }
}

#Preview {
    NavigationStack {
        MenuView()
            .environment(Model())
    }
}
