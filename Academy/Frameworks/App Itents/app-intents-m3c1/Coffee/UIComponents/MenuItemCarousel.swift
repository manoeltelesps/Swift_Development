import SwiftUI

struct MenuItemCarousel: View {
    
    @Environment(Model.self) var model
    
    let title: String
    let items: [MenuItem]
    
    var body: some View {
        Section {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(items) { item in
                        MenuItemCard(
                            item: item,
                            isFavorite: model.isFavorite(item: item),
                            didAddToBag: {
                                model.bag.add(item)
                            },
                            didToggleFavorite: {
                                model.toogleFavorite(for: item)
                            }
                        )
                        .frame(width: .cardWidth)
                        .padding(.vertical)
                    }
                }
                .scrollTargetLayout()
            }
            .safeAreaPadding(.horizontal)
            .scrollTargetBehavior(.viewAligned)
        } header: {
            HStack {
                Text(title)
                    .font(.title3.bold())
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            .padding(.bottom, -8)
        }
    }
}
