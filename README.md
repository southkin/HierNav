# HierNav

> I don't know how 3-column navigation is supposed to work,  
> so I just made one that *feels* like it does.

HierNav is a SwiftUI-compatible navigation system that emulates multi-column hierarchical navigation across platforms — including iOS, macOS, and tvOS (sort of).  

It supports up to **three columns**, handles **back gestures**, **section-based navigation**, and does its best to preserve environment values even when you throw `AnyView` into the mix (you shouldn't, but you will).

## ✨ Features

- 🔀 **Dynamic Column Handling**  
  Automatically switches between 1–3 column layouts based on platform, screen size, and your desperate wishes.

- 🧱 **Stack vs Single Mode**  
  Each column can independently be a navigation stack or a single static view.

- 🧩 **Composable Architecture**  
  Uses `CurrentValueSubject<[AnyView], Never>` as navigation state stream per column — great for declarative + imperative hybrids.

- 🚀 **HNLink Navigation**  
  One component to rule them all: `HNLink` lets you push, present, or popover any destination view with minimal fuss.

- 🍎 **Platform-aware**  
  Takes into account `.horizontalSizeClass` and platform type (`iOS`, `macOS`, etc.) to decide layout.

- 🤡 **Survives SplitView Weirdness**  
  Handles the "weird invisible zone" where SwiftUI `NavigationSplitView` refuses to show up.

## 📦 Example Usage

```swift
HierNavView(style: .split3Columns([
    .mac(minWidth: 350),
    .iOS(minWidth: 300)
])) {
    RootView()
}

### To navigate:
```swift
HNLink("Go deeper", actionType: .push) {
    DetailView()
}
```

### Present modally:
```swift
HNLink("Open modal", actionType: .present) {
    ModalContent()
}
```

### Popover (just don’t ask how it’s anchored):
```swift
HNLink("Show Popover", actionType: .popover) {
    PopoverContent()
}
```

## 😩 Known Issues
- 3-column layout may produce mild existential dread on small screens. This is normal.
- Modal presentation style customization is not yet supported (because SwiftUI said no).
- If you wrap too many views in AnyView, don’t be surprised when environment values disappear.

## 🤷‍♂️ Why
Because NavigationSplitView is too magical to be predictable,
and NavigationStack alone feels like trying to dig a tunnel with a straw.

## 📄 License
MIT. Do what you want, but don’t blame me when it doesn’t work on watchOS.
