//
//  HNLink.swift
//  HierNav
//
//  Created by kin on 5/16/25.
//

import SwiftUI

public enum HNType {
    /// 1. HierNavContainer 내부에 있을때는 HierNavView 의 push
    /// 2. 1번이 아닌 상황에서는 present 로 동작
    case push
    case present
    case popover(target: any View)
}

public struct HNLink<Label: View, Destination: View>: View {
    let label: Label
    let destination: Destination
    let actionType: HNType
    
    @Environment(\.hierNavView) private var hierNavView
    
    public init(actionType: HNType, @ViewBuilder label: () -> Label, @ViewBuilder destination: () -> Destination) {
        self.label = label()
        self.destination = destination()
        self.actionType = actionType
    }
    
    public var body: some View {
        Button {
            switch actionType {
            case .push:
                if let nav = hierNavView {
                    nav.push(view: destination)
                }
                else {
                    print("🚧 HierNavView가 없습니다. 일반 네비게이션 푸시를 시도해야 합니다.")
                }
            case .present:
                print("🚧 모달 프리젠트 동작 추가 필요")
            case .popover(let target):
                print("🚧 팝오버 동작 추가 필요 - 타겟: \(target)")
            }
        } label: {
            label
        }
    }
}