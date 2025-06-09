// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI

/// HierNav 프레임워크의 메인 진입점
///
/// HierNav는 SwiftUI 기반의 다단계 계층 내비게이션 UI를 구현하기 위한 프레임워크입니다.
/// 화면 너비, 디바이스 종류, 스타일 설정에 따라 자동으로 1~3 컬럼 뷰 레이아웃을 구성하며,
/// 사용자 상호작용에 따라 뷰를 동적으로 push, present, popover할 수 있습니다.
///
/// ## 주요 구성 요소
/// - `HierNavView`: 메인 계층 내비게이션 뷰
/// - `HNLink`: 내비게이션 액션을 수행하는 링크 컴포넌트
/// - `HierNavViewStyle`: 뷰 스타일 정의
/// - `HNType`: 링크 액션 타입 정의
///
/// ## 사용 예시
/// ```swift
/// HierNavView(style: .split2Columns(minWidth: 600)) {
///     ContentView()
/// }
/// .environment(\.hierNavView, navModel)
/// ```
///
/// ```swift
/// HNLink("상세보기", actionType: .push) {
///     DetailView()
/// }
/// ```

// MARK: - Public API Re-exports

// Core Types
public typealias HierNav = HierNavView

// View Components
// HierNavView는 이미 public으로 선언됨
// HNLink는 이미 public으로 선언됨

// Enums
// HierNavViewStyle은 이미 public으로 선언됨
// HNType은 이미 public으로 선언됨

// Models
// HierNavModel은 이미 public으로 선언됨

// MARK: - Framework Version Info

/// HierNav 프레임워크 버전 정보
public struct HierNavInfo {
    /// 프레임워크 버전
    public static let version = "1.0.0"
    
    /// 프레임워크 이름
    public static let name = "HierNav"
    
    /// 지원하는 플랫폼
    public static let supportedPlatforms = ["iOS 15.0+", "macOS 14.0+"]
    
    /// 빌드 정보
    public static let buildInfo = "SwiftUI + Combine based hierarchical navigation framework"
}


#Preview(body: {
    HierNav(style: .split3Columns([
        .iOS(minWidth: 400),
        .mac(minWidth: 400)
    ])) {
        Text("Hello, World!")
        HNLink("test", actionType: .push) {
            Text("asdf")
        }
    }
})
