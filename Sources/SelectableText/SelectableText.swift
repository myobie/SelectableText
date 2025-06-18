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
#if canImport(AppKit)
import AppKit
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
    private var menuBuilder: (([UIMenuElement], UITextView) -> UIMenu)? = nil
#endif
#if canImport(AppKit)
    private var menuBuilder: ((NSMenu, NSTextView) -> NSMenu)? = nil
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
    /// - Parameter builder: A closure that receives the system-suggested menu items and the text view
    ///   and returns a new menu to display.
    public func editMenu(_ builder: @escaping ([UIMenuElement], UITextView) -> UIMenu) -> SelectableText {
        var copy = self
        copy.menuBuilder = builder
        return copy
    }
#endif
  
#if canImport(AppKit)
    /// Applies a custom builder for the edit menu on macOS.
    /// - Parameter builder: A closure that receives the system-suggested menu and the text view
    ///   and returns a new menu to display.
    public func editMenu(_ builder: @escaping (NSMenu, NSTextView) -> NSMenu) -> SelectableText {
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
                menuBuilder: menuBuilder,
                maxLayoutWidth: proxy.maxWidth,
                layoutHeight: $layoutHeight
            )
#else
            SelectableTextRepresentable(
                text: text,
                attributedText: attributedText,
                menuBuilder: menuBuilder,
                maxLayoutWidth: proxy.maxWidth,
                layoutHeight: $layoutHeight
            )
#endif
        }
        .frame(height: layoutHeight)
    }
}

#Preview {
    struct Demo: View {
        @State private var alertBody = ""
        @State private var showAlert = false
      
        private func shout(_ msg: String) {
            alertBody = msg.uppercased()
            showAlert = true
        }

        var body: some View {
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
            let nsAttributedText = NSAttributedString(string: "With custom menu: \(text)", attributes: attributes)
        
            Form {
                SelectableText(text)
                SelectableText(attributedText)
                SelectableText(nsAttributedText)
#if canImport(UIKit)
                    .editMenu { defaults, textView in
                        let shoutAction = UIAction(title: "Shout") { _ in
                            if let selectedTextRange = textView.selectedTextRange,
                               let selectedText = textView.text(in: selectedTextRange),
                               !selectedText.isEmpty {
                              shout(selectedText)
                            }
                        }
                        return UIMenu(children: [shoutAction] + defaults)
                    }
#endif
#if canImport(AppKit)

                    .editMenu { menu, textView in
                        let item = menu.addItem("Shout", at: 2) {
                            let range = textView.selectedRange()
                            let selectedText = (textView.string as NSString).substring(with: range)
                            
                            if !selectedText.isEmpty {
                                shout(selectedText)
                            }
                        }
                        let image = NSImage(systemSymbolName: "speaker", accessibilityDescription: nil)!
                        image.isTemplate = true
                        item.image = image
                        return menu
                    }
#endif
            }
                .alert("Shout!", isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(alertBody)
                }
        }
    }
  
    return Demo()
}

//#if canImport(UIKit)
//extension UIResponder {
//    private static weak var _firstResponder: UIResponder? = nil
//    public static var firstResponder: UIResponder? {
//        _firstResponder = nil
//        UIApplication.shared.sendAction(#selector(UIResponder._trapFirstResponder), to: nil, from: nil, for: nil)
//        return _firstResponder
//    }
//    @objc private func _trapFirstResponder() {
//        UIResponder._firstResponder = self
//    }
//}
//#endif

