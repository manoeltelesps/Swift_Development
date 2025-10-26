import SwiftUI

extension FormatStyle {
    public static func dolar<Value>() -> Self where Self == FloatingPointFormatStyle<Value>.Currency, Value : BinaryFloatingPoint {
        return .currency(code: "USD")
    }
}

extension EdgeInsets {
    init(_ value: CGFloat) {
        self = EdgeInsets(top: value, leading: value, bottom: value, trailing: value)
    }
}

extension ShapeStyle where Self == BackgroundStyle {
    static var listBackground: some ShapeStyle {
        AnyShapeStyle(Color.init(uiColor: UIColor.systemGroupedBackground))
    }
}

extension CGFloat {
    static var listRowSpacing = 8.0
    static var cardWidth = 320.0
}

extension Image {
    func thumbnail() -> some View {
        self
            .resizable()
            .frame(width: 32, height: 32)
            .aspectRatio(1, contentMode: .fill)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
    
    func card() -> some View {
        self
            .resizable()
            .frame(height: 320)
            .aspectRatio(1, contentMode: .fill)
    }
}

extension View {
    func lightShadow() -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.black.opacity(0.5))
                    .shadow(radius: 4)
            )
    }
}
