//  NSMenuItem+addItemWith.swift
//  SelectableText
//
//  Created by Nathan Herald on 2025‑06‑18.
//

#if canImport(AppKit)
import AppKit
import ObjectiveC.runtime

/// Internal wrapper that bridges a Swift closure to the selector–based
/// `NSMenuItem` API. Each instance is retained for the lifetime of the
/// corresponding menu item.
private final class _NSMenuClosureSleeve: NSObject {
    let block: () -> Void
    init(_ block: @escaping () -> Void) { self.block = block }
    @objc func invoke() { block() }
}

public extension NSMenu {
    /// Appends an `NSMenuItem` backed by a Swift closure and returns it.
    /// - Parameters:
    ///   - title:         The menu item’s title.
    ///   - keyEquivalent: Keyboard shortcut (default: none).
    ///   - handler:       Closure executed when the user chooses the item.
    /// - Returns: The newly created and already‑added `NSMenuItem`.
    @discardableResult
    func addItem(_ title: String,
                 keyEquivalent: String = "",
                 handler: @escaping () -> Void) -> NSMenuItem {

        let sleeve = _NSMenuClosureSleeve(handler)

        let item = NSMenuItem(
            title: title,
            action: #selector(_NSMenuClosureSleeve.invoke),
            keyEquivalent: keyEquivalent)
        item.target = sleeve

        // Retain the sleeve for as long as the item exists, otherwise the
        // target would be deallocated before the selector fires.
        objc_setAssociatedObject(
            item,
            Unmanaged.passUnretained(item).toOpaque(),
            sleeve,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        addItem(item)
        return item
    }
    
    /// Appends an `NSMenuItem` backed by a Swift closure and returns it.
    /// - Parameters:
    ///   - title:         The menu item’s title.
    ///   - keyEquivalent: Keyboard shortcut (default: none).
    ///   - handler:       Closure executed when the user chooses the item.
    /// - Returns: The newly created and already‑added `NSMenuItem`.
    @discardableResult
    func addItem(_ title: String,
                 at index: Int,
                 keyEquivalent: String = "",
                 handler: @escaping () -> Void) -> NSMenuItem {

        let sleeve = _NSMenuClosureSleeve(handler)

        let item = NSMenuItem(
            title: title,
            action: #selector(_NSMenuClosureSleeve.invoke),
            keyEquivalent: keyEquivalent)
        item.target = sleeve

        // Retain the sleeve for as long as the item exists, otherwise the
        // target would be deallocated before the selector fires.
        objc_setAssociatedObject(
            item,
            Unmanaged.passUnretained(item).toOpaque(),
            sleeve,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        let safeIndex = Swift.max(0, Swift.min(index, items.count))
        insertItem(item, at: safeIndex)
        return item
    }
}

func addToMenu() {
    let menu = NSMenu()
    menu.addItem("Shout") {
        print("yo")
    }
}

#endif
