import SwiftUI

struct OrderRow: View {
    
    let order: Order
    let didTapBuyAgain: () -> Void
    
    var title: String {
        firstItem + moreItemsText
    }
    
    var moreItemsText: String {
        let count = order.items.count
        return count == 1 ? "" : " & \(count - 1) more"
    }
    
    var firstItem: String {
        order.items.first?.menuItem.name ?? ""
    }
    
    var image: String {
        order.items.first?.menuItem.image ?? ""
    }
    
    var body: some View {
        VStack {
            HStack {
                
                Image(
                    image
                )
                .thumbnail()
                
                Text(
                    title
                )
                .font(
                    .headline
                )
                
                Spacer()
                
                Text(
                    order.total,
                    format:
                            .dolar()
                )
                .font(
                    .subheadline
                )
            }
            
            HStack {
                Spacer()
                
                Button(
                    "Buy Again"
                ) {
                    didTapBuyAgain()
                }
                .buttonStyle(
                    .borderedProminent
                )
            }
        }
        .padding()
        .listRowInsets(
            EdgeInsets()
        )
    }
}

#Preview {
    List {
        OrderRow(
            order: .init(
                items: [
                    .init(
                        menuItem: .init(
                            id: "1",
                            name: "Coffee",
                            price: 0.99,
                            description: "",
                            image: "cafe"
                        ),
                        quantity: 1
                    )
                ]
            ),
            didTapBuyAgain: {}
        )
    }
}
