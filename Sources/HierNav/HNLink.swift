//
//  HNLink.swift
//  HierNav
//
//  Created by kin on 5/16/25.
//
import SwiftUI

/// 계층 내비게이션을 위한 링크 컴포넌트
public struct HNLink<Label: View, Destination: View>: View {
    /// 액션 타입
    private let actionType: HNType
    
    /// 레이블 뷰 빌더
    private let label: () -> Label
    
    /// 목적지 뷰 빌더
    private let destination: () -> Destination
    
    /// 환경에서 HierNavModel을 가져옴
    @Environment(\.hierNavView) private var navModel
    @Environment(\.hierNavSection) private var section
    
    /// Present 상태 관리
    @State private var isPresentingModal = false
    
    /// Popover 상태 관리
    @State private var isPresentingPopover = false
    
    /// 초기화
    /// - Parameters:
    ///   - actionType: 수행할 액션 타입
    ///   - label: 표시할 레이블
    ///   - destination: 이동할 목적지 뷰
    public init(
        actionType: HNType,
        @ViewBuilder label: @escaping () -> Label,
        @ViewBuilder destination: @escaping () -> Destination
    ) {
        self.actionType = actionType
        self.label = label
        self.destination = destination
    }
    
    public var body: some View {
        Button(action: performAction) {
            label()
        }
        .sheet(isPresented: $isPresentingModal) {
            destination()
        }
        .popover(isPresented: $isPresentingPopover) {
            destination()
        }
    }
    
    /// 액션 타입에 따른 동작 수행
    private func performAction() {
        switch actionType {
        case .push:
            pushView()
        case .present:
            presentView()
        case .popover:
            showPopover()
        }
    }
    
    /// 뷰를 푸시
    private func pushView() {
        guard let navModel = navModel else {
            print("Warning: HierNavModel not found in environment")
            return
        }
        if let section = section {
            navModel.addView(view: destination().toAnyView, at: section)
        }
        else {
            navModel.addView(view: destination().toAnyView)
        }
    }
    
    /// 뷰를 모달로 present
    private func presentView() {
        isPresentingModal = true
    }
    
    /// 뷰를 popover로 표시
    private func showPopover() {
        isPresentingPopover = true
    }
}

// MARK: - Convenience Initializers

extension HNLink where Label == Text {
    /// 텍스트 레이블을 사용하는 편의 초기화
    /// - Parameters:
    ///   - title: 레이블 텍스트
    ///   - actionType: 수행할 액션 타입
    ///   - destination: 이동할 목적지 뷰
    public init(
        _ title: String,
        actionType: HNType,
        @ViewBuilder destination: @escaping () -> Destination
    ) {
        self.init(
            actionType: actionType,
            label: { Text(title) },
            destination: destination
        )
    }
}

extension HNLink where Label == Image {
    /// 이미지 레이블을 사용하는 편의 초기화
    /// - Parameters:
    ///   - systemName: SF Symbol 이름
    ///   - actionType: 수행할 액션 타입
    ///   - destination: 이동할 목적지 뷰
    public init(
        systemImage systemName: String,
        actionType: HNType,
        @ViewBuilder destination: @escaping () -> Destination
    ) {
        self.init(
            actionType: actionType,
            label: { Image(systemName: systemName) },
            destination: destination
        )
    }
}
