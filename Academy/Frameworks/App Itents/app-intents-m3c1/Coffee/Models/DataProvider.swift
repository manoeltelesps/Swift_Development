import Foundation

struct DataProvider {
    
    static func loadFromJSONFile<T: Decodable>(named name: String) throws -> [T] {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json") else { return [] }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([T].self, from: data)
    }
    
    static func allFoods() throws -> [MenuItem] {
        try loadFromJSONFile(named: "foods_data")
    }
    
    static func allDrinks() throws -> [MenuItem] {
        try loadFromJSONFile(named: "drinks_data")
    }
    
    static func allOrders() throws -> [Order] {
        try loadFromJSONFile(named: "orders_data")
    }
}
