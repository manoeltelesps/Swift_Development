import Foundation

struct Order: Identifiable, Decodable {
    let id: String
    let date: Date
    var items: [Item]
    
    var total: Double {
        items.reduce(0) { $0 + $1.subtotal }
    }
    
    init(
        id: String = UUID().uuidString,
        date: Date = .now,
        items: [Item] = []
    ) {
        self.id = id
        self.date = date
        self.items = items
    }
}

extension Order {
    mutating func add(_ menuItem: MenuItem) {
        if isAlreadyAdded(menuItem: menuItem) {
            add(existingItem: menuItem)
        } else {
            add(newMenuItem: menuItem)
        }
    }
    
    mutating func remove(_ menuItem: MenuItem) {
        guard let index = index(for: menuItem) else { return }
        
        if items[index].quantity <= 1 {
            items.remove(at: index)
        } else {
            items[index].quantity -= 1
        }
    }
}

private extension Order {
    mutating func add(existingItem menuItem: MenuItem) {
        guard let index = index(for: menuItem) else { return }
        items[index].quantity += 1
    }
    
    mutating func add(newMenuItem menuItem: MenuItem) {
        let orderItem = Item(menuItem: menuItem, quantity: 1)
        items.append(orderItem)
    }
    
    func isAlreadyAdded(menuItem: MenuItem) -> Bool {
        items.contains { item in
            item.menuItem.id == menuItem.id
        }
    }
    
    func index(for menuItem: MenuItem) -> Int? {
        items.firstIndex { item in
            item.menuItem.id == menuItem.id
        }
    }
}

extension Order {
    struct Item: Decodable {
        let menuItem: MenuItem
        var quantity: Int
        
        var subtotal: Double {
            menuItem.price * Double(quantity)
        }
    }
}
