import SwiftUI

struct MenuItemCard: View {
    
    let item: MenuItem
    let isFavorite: Bool
    let didAddToBag: () -> Void
    let didToggleFavorite: () -> Void
    
    
    
    var body: some View {
        VStack(spacing: .zero) {
            
            Image(item.image)
                .card()
                
            HStack {
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.headline)
                    Text(item.price, format: .dolar())
                        .font(.footnote)
                }
                
                Spacer()
                
                Button("Add to Bag") {
                    didAddToBag()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        
        .background(.background.secondary)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .lightShadow()
        .overlay(alignment: .topTrailing) {
            FavoriteButton(isFavorite: isFavorite) {
                didToggleFavorite()
            }
            .padding()
        }
    }
}

#Preview {
    @Previewable @State var isFavorite = false
    
    MenuItemCard(
        item: .init(
            id: "1",
            name: "Coffee",
            price: 0.99,
            description: "",
            image: "cafe"
        ),
        isFavorite: isFavorite,
        didAddToBag: {},
        didToggleFavorite: {
            isFavorite.toggle()
        }
    )
    .padding()
    .background(.background.secondary)
}
