//
//  SelectableText.swift
//
//
//  Created by Kevin Hermawan on 14/02/24.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

///  A view that displays one or more lines of read-only selectable text.
///
/// Initializing with plain text:
/// ```swift
/// SelectableText("This is some selectable text.")
/// ```
///
/// Initializing with `AttributedString`:
/// ```swift
/// let attributes: AttributeContainer = [
///     .foregroundColor: NSColor.systemPink,
///     .font: NSFont.preferredFont(forTextStyle: .body)
/// ]
///
/// let attributedString = AttributedString("This is some styled selectable text.", attributes: attributes)
/// SelectableText(attributedString)
/// ```
///
/// Initializing with `NSAttributedString`:
/// ```swift
/// let nsAttributes: [NSAttributedString.Key: Any] = [
///     .foregroundColor: NSColor.systemPink,
///     .font: NSFont.preferredFont(forTextStyle: .body)
/// ]
///
/// let nsAttributedString = NSAttributedString(string: "This is some styled selectable text.", attributes: nsAttributes)
/// SelectableText(nsAttributedString)
/// ```
public struct SelectableText: View {
    private var text: String? = nil
    private var attributedText: NSAttributedString? = nil
#if canImport(UIKit)
    private var menuBuilder: ((UIMenu) -> UIMenu)? = nil
#endif
    
    @State private var layoutHeight: CGFloat = .zero
    
    /// Initializes the view with plain text.
    /// - Parameter text: The text to be displayed.
    public init(_ text: String) {
        self.text = text
    }
    
    /// Initializes the view with an `AttributedString`.
    /// - Parameter attributedText: The attributed text to be displayed.
    public init(_ attributedText: AttributedString) {
        self.attributedText = NSAttributedString(attributedText)
    }
    
    /// Initializes the view with an `NSAttributedString`.
    /// - Parameter attributedText: The attributed text to be displayed.
    public init(_ attributedText: NSAttributedString) {
        self.attributedText = attributedText
    }

#if canImport(UIKit)
    /// Applies a custom builder for the edit menu on iOS.
    /// - Parameter builder: A closure that receives the system-suggested menu
    ///   and returns a new menu to display.
    public func editMenu(_ builder: @escaping (UIMenu) -> UIMenu) -> SelectableText {
        var copy = self
        copy.menuBuilder = builder
        return copy
    }
#endif
    
    public var body: some View {
        GeometryReader { proxy in
#if canImport(UIKit)
            SelectableTextRepresentable(
                text: text,
                attributedText: attributedText,
                maxLayoutWidth: proxy.maxWidth,
                layoutHeight: $layoutHeight,
                menuBuilder: menuBuilder
            )
#else
            SelectableTextRepresentable(
                text: text,
                attributedText: attributedText,
                maxLayoutWidth: proxy.maxWidth,
                layoutHeight: $layoutHeight
            )
#endif
        }
        .frame(height: layoutHeight)
    }
}

#Preview {
    let text = "This is SelectableText!"
    
#if canImport(UIKit)
    let attributes: [NSAttributedString.Key : Any] = [
        .foregroundColor: UIColor.systemPink,
        .font: UIFont.preferredFont(forTextStyle: .body)
    ]
#elseif canImport(AppKit)
    let attributes: [NSAttributedString.Key : Any] = [
        .foregroundColor: NSColor.systemPink,
        .font: NSFont.preferredFont(forTextStyle: .body)
    ]
#endif
    
    let attributedText = AttributedString(text, attributes: AttributeContainer(attributes))
    let nsAttributedText = NSAttributedString(string: text, attributes: attributes)
    
    return Form {
        SelectableText(text)
        SelectableText(attributedText)
        SelectableText(nsAttributedText)
    }
}
