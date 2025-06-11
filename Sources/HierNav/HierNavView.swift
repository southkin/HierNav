//
//  HierNavView.swift
//  HierNav
//
//  Created by kin on 5/30/25.
//


import SwiftUI
import Combine

/// 계층 내비게이션의 메인 뷰
public struct HierNavView<Root: View>: View {
    /// 내부 뷰 스택 모델
    @StateObject private var model: HierNavModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    public init(
        style: HierNavViewStyle,
        @ViewBuilder root: @escaping () -> Root
    ) {
        self._model = StateObject(wrappedValue: .init(style: style, root: root().toAnyView))
    }
    
    public var body: some View {
        GeometryReader { geometry in
            contentView(for: geometry.size)
        }
        .environment(\.hierNavView, model)
    }
    @ViewBuilder
    private func contentView(for size: CGSize) -> some View {
        let _ = model.updateViewWidth(size.width, sizeClass: horizontalSizeClass)
        let columnCount = model.currentColumnCount
        if columnCount == 1 {
            // 단일 컬럼 레이아웃
            singleColumnLayout()
        } else {
            // 다중 컬럼 레이아웃
            multiColumnLayout(columnCount: columnCount)
        }
    }
    @ViewBuilder
    private func singleColumnLayout() -> some View {
        HierNavContainer(mode: .stack, stream: model.viewStreams[0])
            .environment(\.hierNavSection, 0)
            .id(UUID())
    }
    @ViewBuilder
    private func multiColumnLayout(columnCount: Int) -> some View {
        switch columnCount {
        case 2:
            NavigationSplitView {
                HierNavContainer(mode: .single, stream: model.viewStreams[0])
                    .environment(\.hierNavSection, 0)
                    .id(UUID())
            } detail: {
                HierNavContainer(mode: .stack, stream: model.viewStreams[1])
                    .environment(\.hierNavSection, 1)
                    .id(UUID())
            }

        case 3:
            NavigationSplitView {
                HierNavContainer(mode: .single, stream: model.viewStreams[0])
                    .environment(\.hierNavSection, 0)
                    .id(UUID())
            } content: {
                HierNavContainer(mode: .single, stream: model.viewStreams[1])
                    .environment(\.hierNavSection, 1)
                    .id(UUID())
            } detail: {
                HierNavContainer(mode: .stack, stream: model.viewStreams[2])
                    .environment(\.hierNavSection, 2)
                    .id(UUID())
            }

        default:
            EmptyView()
        }
    }
}



