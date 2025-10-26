import SwiftUI

struct OrderItemCard: View {
    
    let item: Order.Item
    let isEditing: Bool
    let didIncrement: () -> Void
    let didDecrement: () -> Void
    
    init(
        item: Order.Item,
        isEditing: Bool = false,
        didIncrement: @escaping () -> Void = {},
        didDecrement: @escaping () -> Void = {}
    ) {
        self.item = item
        self.isEditing = isEditing
        self.didIncrement = didIncrement
        self.didDecrement = didDecrement
    }
    
    var body: some View {
        HStack {
            
            Image(item.menuItem.image)
                .thumbnail()
            
            VStack {
                HStack {
                    Text(item.menuItem.name)
                        .font(.headline)
                    
                    Spacer()
                    
                    if isEditing {
                        Stepper {
                            HStack {
                                Spacer()
                                Text(item.quantity, format: .number)
                            }
                        } onIncrement: {
                            didIncrement()
                        } onDecrement: {
                            didDecrement()
                        }
                    } else {
                        HStack {
                            Text(item.quantity, format: .number)
                            Text("x")
                            Text(item.subtotal, format: .dolar())
                        }
                        .font(.callout)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    List {
        OrderItemCard(
            item: Order.Item(
                menuItem: .init(
                    id: "1",
                    name: "Coffee",
                    price: 0.99,
                    description: "",
                    image: ""
                ),
                quantity: 1
            )
        )
    }
}
