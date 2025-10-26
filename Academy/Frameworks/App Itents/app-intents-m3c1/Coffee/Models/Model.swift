import Foundation

@MainActor
@Observable
class Model {
    
    var selectedTab: CoffeeTab = .menu
    var drinks: [MenuItem] = []
    var foods: [MenuItem] = []
    var favorites: [MenuItem] = []
    var orders: [Order] = []
    var bag: Order = Order()
    
    init() {
        try? loadLocalData()
    }
}

// Actions
extension Model {
    func loadLocalData() throws {
        drinks = try DataProvider.allDrinks()
        foods = try DataProvider.allFoods()
        orders = try DataProvider.allOrders()
    }
    
    func buyAgain(_ order: Order) {
        bag = order
    }
    
    func finishOrder() {
        orders.append(bag)
        bag = Order()
    }
    
    func isFavorite(item: MenuItem) -> Bool {
        favorites.contains(item)
    }
    
    func toogleFavorite(for item: MenuItem) {
        if isFavorite(item: item) {
            favorites.removeAll(where: { $0.id == item.id })
        } else {
            favorites.append(item)
        }
    }
}

// Lookup helpers
extension Model {
    func find(product name: String) -> MenuItem? {
        if let drink = drinks.first(where: { $0.name == name }) {
            return drink
        }
        if let food = foods.first(where: { $0.name == name }) {
            return food
        }
        return nil
    }
}
