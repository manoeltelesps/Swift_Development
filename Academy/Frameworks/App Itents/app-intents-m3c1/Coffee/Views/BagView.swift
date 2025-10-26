import SwiftUI

struct BagView: View {
    
    @Environment(Model.self) var model
    @State var isEditing: Bool = false
    
    var isEmptyBag: Bool {
        model.bag.items.isEmpty
    }
    
    var body: some View {
        List {
            Section {
                ForEach(model.bag.items, id: \.menuItem.id) { item in
                    OrderItemCard(
                        item: item,
                        isEditing: isEditing,
                        didIncrement: { model.bag.add(item.menuItem) },
                        didDecrement: { model.bag.remove(item.menuItem) }
                    )
                }
                .listRowInsets(EdgeInsets())
            }
            
            totalSection
        }
        .listRowSpacing(.listRowSpacing)
        .listSectionSpacing(.compact)
        .navigationTitle("Bag")
        .overlay { emptyState }
        .toolbar { toolbarContent }
    }
    
    @ViewBuilder
    var totalSection: some View {
        if !isEmptyBag {
            Section {
                HStack {
                    Text("Total")
                    Spacer()
                    Text(model.bag.total, format: .dolar())
                }
                .bold()
            }
        }
    }
    
    @ViewBuilder
    var emptyState: some View {
        if isEmptyBag {
            ContentUnavailableView(
                "Your bag is empty",
                systemImage: "basket",
                description: Text("Add menu items to finish your order")
            )
        }
    }
    
    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        if !isEmptyBag {
            ToolbarItem(placement: .topBarLeading) {
                Button(isEditing ? "Done" : "Edit") {
                    isEditing.toggle()
                }
            }
            
            ToolbarItem {
                Button("Order") {
                    model.finishOrder()
                }
                .disabled(isEditing)
            }
        }
    }
}

#Preview {
    NavigationStack {
        BagView()
            .environment(Model())
    }
}
