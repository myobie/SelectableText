//
//  SelectableTextRepresentable+AppKit.swift
//
//
//  Created by Kevin Hermawan on 14/02/24.
//

#if canImport(UIKit)
import UIKit
import SwiftUI

struct SelectableTextRepresentable: UIViewRepresentable {
    var text: String? = nil
    var attributedText: NSAttributedString? = nil
    var menuBuilder: (([UIMenuElement], UITextView) -> UIMenu)? = nil
    
    var maxLayoutWidth: CGFloat = .zero
    @Binding var layoutHeight: CGFloat
  
    func makeCoordinator() -> MenuCoordinator {
        MenuCoordinator { suggested, textView in
          if let menuBuilder = menuBuilder {
             return menuBuilder(suggested, textView)
          } else {
            return UIMenu(children: suggested)
          }
        }
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = BaseTextView()
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.font = .preferredFont(forTextStyle: .body)
        
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.adjustsFontForContentSizeCategory = true
        textView.maxLayoutWidth = self.maxLayoutWidth

        if let text {
            textView.text = text
        }

        if let attributedText {
            textView.attributedText = attributedText
        }

        if #available(iOS 16, *) {
            if menuBuilder != nil {
                textView.delegate = context.coordinator
            }
        }
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if let text {
            uiView.text = text
        }
        
        if let attributedText {
            uiView.attributedText = attributedText
        }
        
        DispatchQueue.main.async {
            self.layoutHeight = uiView.intrinsicContentSize.height
        }
    }
}
#endif
