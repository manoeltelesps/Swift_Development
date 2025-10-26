import SwiftUI

struct OrdersView: View {
    
    @Environment(Model.self) var model
    
    var sortedOrders: [Order] {
        model.orders.sorted { $0.date > $1.date }
    }
    
    var body: some View {
        List(sortedOrders) { order in
            OrderRow(order: order) {
                model.buyAgain(order)
            }
        }
        .listRowSpacing(.listRowSpacing)
        .navigationTitle("Orders")
        .overlay { emptyState }
    }
    
    @ViewBuilder
    var emptyState: some View {
        if model.orders.isEmpty {
            ContentUnavailableView(
                "No past orders yet",
                systemImage: "receipt",
                description: Text("Start your first order and it’ll show up here")
            )
        }
    }
}

#Preview {
    NavigationStack {
        OrdersView()
            .environment(Model())
    }
}
