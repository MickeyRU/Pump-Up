import SwiftUI

struct StatCardStyle: ViewModifier {
    @Environment(\.colorSchemeContrast) private var contrast
    @Environment(\.colorScheme) private var scheme
    
    private var borderColor: Color {
        contrast == .increased ? Color(UIColor.opaqueSeparator) : Color(UIColor.separator)
    }
    
    private var borderWidth: CGFloat {
        contrast == .increased ? 1.5 : 1
    }
    
    private var shadowColor: Color {
        scheme == .dark ? .black.opacity(0.25) : .black.opacity(0.05)
    }
    
    func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: 12, style: .continuous)
        
        content
            .background(.regularMaterial, in: shape)
            .overlay(shape.strokeBorder(borderColor, lineWidth: borderWidth))
            .shadow(color: shadowColor, radius: 6, x: 0, y: 3)
    }
}

extension View {
    func statCardStyle() -> some View { modifier(StatCardStyle()) }
}
