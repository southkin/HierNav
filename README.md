# HierNav

## 개요
HierNav는 SwiftUI 기반의 다단계 계층 내비게이션 UI를 구현하기 위한 프레임워크다.
화면 너비, 디바이스 종류, 스타일 설정에 따라 자동으로 1~3 컬럼 뷰 레이아웃을 구성하며, 사용자 상호작용에 따라 뷰를 동적으로 push, present, popover할 수 있는 구조를 가진다.

## 📦 요구사항 요약
|항목|설명|
|---|---|
|플랫폼|iOS / iPadOS / macOS|
|사용 기술|SwiftUI, Combine|
|목적|다중 컬럼 내비게이션 UI를 동적으로 구성 및 제어|
|동작 방식|화면 너비, 스타일, 사용자의 액션에 따라 동적으로 push/present/popup 등 수행|
|뷰 관리|내부 HierNavModel에서 모든 뷰 스택을 추적 및 관리|

## 🎛️ View 스타일 정의
```swift
public enum HierNavViewStyle {
    case single
    case split2Columns(minWidth: Double)
    case split3Columns(minWidth: Double)
    
    func colCount(viewWidth:Double) -> Int
    var minWidth: Double
}
```

## 🧱 Core 타입 인터페이스
### ✅ HierNavView<Root: View>
```swift
public struct HierNavView<Root: View>: View
```

#### 📥 초기화
```swift
public init(style: HierNavViewStyle, @ViewBuilder root: @escaping () -> Root)
```

#### 🧠 프로퍼티
- style: HierNavViewStyle
- root: () -> Root
- model: HierNavModel — 내부 뷰 스택 모델
- emptyView: () -> AnyView — 비어있을 때 보여줄 기본 뷰

#### 🧩 주요 동작
- 해상도 및 스타일 기반으로 컬럼 수 계산
- 해당 컬럼 수만큼 뷰 publish
- 내부적으로 HierNavContainer 사용

### ✅ HierNavModel: ObservableObject
```swift
public class HierNavModel: ObservableObject
```
#### 📥 내부 상태
- _views: [AnyView] — 전체 뷰 히스토리
- views: [CurrentValueSubject<HierNavContentType, Never>] — 실시간 컬럼 데이터
- publish(colCount: Int) — subject에 publish 하여 특정 컬럼 업데이트 유도
- push(view: AnyView) — 새 뷰 push

### ✅ enum HierNavContentType
```swift
enum HierNavContentType {
    case single(AnyView) // 단일 컨텐츠
    case stack([AnyView]) // 스택뷰로 표현
}
```

### ✅ HierNavContainer: View
```swift
public struct HierNavContainer: View
```
#### 📥 초기화
```swift
public init(position: Int, subject: CurrentValueSubject<HierNavContentType, Never>)
```
#### 📥 상태
- @StateObject private var model: HierNavContainerModel
- @State private var path: NavigationPath
- position: Int — 컬럼 인덱스
#### 🧩 동작
- .single이면 해당 뷰를 보여줌
- .stack이면 NavigationPath 기반으로 여러 뷰를 구성

### ✅ HierNavContainerModel: ObservableObject
```swift
class HierNavContainerModel: ObservableObject
```
#### 📥 초기화
```swift
init(subject: CurrentValueSubject<HierNavContentType, Never>)
```
#### 📥 상태
- @StateObject private var model: HierNavContainerModel
- @State private var path: NavigationPath
- position: Int — 컬럼 인덱스

#### 🧩 동작
- .single이면 해당 뷰를 보여줌
- .stack이면 NavigationPath 기반으로 여러 뷰를 구성

### ✅ HierNavContainerModel: ObservableObject
```swift
class HierNavContainerModel: ObservableObject
```
#### 📥 초기화
```swift
init(subject: CurrentValueSubject<HierNavContentType, Never>)
```
#### 📥 상태
- @Published var content: HierNavContentType
- Combine을 사용해 subject에서 뷰 업데이트 수신

### ✅ HNLink: View
```swift
public struct HNLink<Label: View, Destination: View>: View
```
#### 📥 초기화
```swift
public init(
  actionType: HNType,
  @ViewBuilder label: () -> Label,
  @ViewBuilder destination: () -> Destination
)
```
#### 🧰 액션 타입 정의
```swift
public enum HNType {
    case push
    case present
    case popover(target: any View)
}
```

### 🌐 환경 변수
```swift
//EnvironmentKey: \.hierNavView
struct HierNavViewKey: EnvironmentKey {
    static let defaultValue: HierNavModel? = nil
}
extension EnvironmentValues {
    var hierNavView: HierNavModel? {
        get { self[HierNavViewKey.self] }
        set { self[HierNavViewKey.self] = newValue }
    }
}
```
## 피드백
```swift
//1. 화면크기에 따라 colCount 가 달라지므로 화면크기를 받는것이 필요해보임
var colCount: Int
func colCount(viewWidth:Double) -> Int

//2. emptyView 는 여기에서 받을 이유 없어보임, colCount 는 전체 _views 의 상황에 따라 지정되는것이므로 따로 지정할 이유 없어보임
func push(view: AnyView, colCount: Int, emptyView: () -> AnyView) 
func push(view: AnyView) 
```