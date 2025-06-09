//
//  HierNavContentType.swift
//  HierNav
//
//  Created by kin on 5/30/25.
//

import SwiftUI

/// 계층 내비게이션 컨테이너의 콘텐츠 타입
public enum HierNavContentType: Equatable {
    /// 단일 콘텐츠
    case single(AnyView)
    
    /// 여러 뷰로 구성된 스택
    case stack([AnyView])
    
    /// Equatable 준수를 위한 구현
    public static func == (lhs: HierNavContentType, rhs: HierNavContentType) -> Bool {
        switch (lhs, rhs) {
        case (.single, .single):
            return true
        case (.stack(let lhsViews), .stack(let rhsViews)):
            return lhsViews.count == rhsViews.count
        default:
            return false
        }
    }
    
    /// 빈 콘텐츠인지 확인
    public var isEmpty: Bool {
        switch self {
        case .single:
            return false
        case .stack(let views):
            return views.isEmpty
        }
    }
    
    /// 스택의 뷰 개수 반환
    public var count: Int {
        switch self {
        case .single:
            return 1
        case .stack(let views):
            return views.count
        }
    }
}
