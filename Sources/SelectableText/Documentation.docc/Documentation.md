# ``SelectableText``

A view that displays one or more lines of read-only selectable text.

## Overview

``SelectableText`` is a SwiftUI view designed to present text as read-only and selectable, filling a gap left by SwiftUI's standard `Text` view which does not support text selection. It defaults to using a body font appropriate for the platform, but its true utility comes from its support for attributed text. This allows for detailed customization, enabling the direct application of varied text styles—such as font weights, sizes, and colors—within the text's attributes.

### Custom Edit Menu

Use ``editMenu(_:)`` on iOS 16+ and macOS 14+ to customize the system edit menu:

```swift
// UIKit
SelectableText(AttributedString("Hello **world**"))
    .editMenu { suggested, _textView in
        UIMenu(children: [UIAction(title: "Share") { _ in share() }] + suggested)
    }
```

```swift
// AppKit
SelectableText(AttributedString("Hello **world**"))
    .editMenu { menu, _textView in
        menu.addItem("Share") { share() }
        return menu
    }
```
