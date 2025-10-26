import Foundation

struct MenuItem: Identifiable, Equatable, Decodable {
    let id: String
    let name: String
    let price: Double
    let description: String
    let image: String
}
