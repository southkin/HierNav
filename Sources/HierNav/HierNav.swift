// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI
// Core Types
public typealias HierNav = HierNavView


#Preview(body: {
    HierNav(style: .split3Columns([
        .iOS(minWidth: 400),
        .mac(minWidth: 100)
    ])) {
        Text("Hello, World!")
        HNLink("test", actionType: .push) {
            HNLink("test", actionType: .push) {
                HNLink("test", actionType: .push) {
                    HNLink("test", actionType: .popover)
                    {
                        HNLink("test", actionType: .popover) {
                            Text("last")
                        }
                    }
                }
            }
        }
    }
})

import SwiftUI

public extension View {
    var toAnyView: AnyView {
        AnyView(self)
    }
}

