// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI
import Combine

public enum HierNavViewStyle {
    case single
    case split2Columns(minWidth: Double)
    case split3Columns(minWidth: Double)
    
    var colCount: Int {
        switch self {
        case .single: return 1
        case .split2Columns: return 2
        case .split3Columns: return 3
        }
    }
    
    var minWidth: Double {
        switch self {
        case .split2Columns(let minWidth),
             .split3Columns(let minWidth):
            return minWidth
        default:
            return 1
        }
    }
}

enum HierNavContentType {
    case single(AnyView)
    case stack([AnyView])
}

public class HierNavModel: ObservableObject {
    @Published var views: [CurrentValueSubject<HierNavContentType, Never>] = []
    private var _views:[AnyView] = []
    private var cancellables = Set<AnyCancellable>()
    
    func publish(colCount: Int, emptyView: @escaping () -> AnyView) {
        for i in 0..<colCount {
            let content: HierNavContentType
            if i == colCount - 1 {
                content = .stack(Array(_views[i...]))
            } else {
                content = .single(getView(i, emptyView: emptyView))
            }
            if views.count <= i {
                views.append(.init(content))
            } else {
                views[i].send(content)
            }
        }
    }
    
    func push(view: AnyView, colCount: Int, emptyView: @escaping () -> AnyView) {
        _views.append(view)
        publish(colCount: colCount, emptyView: emptyView)
    }
    
    func getView(_ index: Int, emptyView: @escaping () -> AnyView) -> AnyView {
        guard _views.count > index else {
            return emptyView()
        }
        return _views[index]
    }
}

public struct HierNavView<Root: View>: View {
    var maxSupportedColumns: Int {
#if os(macOS)
        return 3
#elseif os(iOS)
        return UIDevice.current.userInterfaceIdiom == .pad ? 3 : 1
#else
        return 1
#endif
    }
    let style: HierNavViewStyle
    var model = HierNavModel()
    var emptyView: () -> AnyView = { AnyView(Text("Empty...")) }
    var root: () -> Root
    
    public init(style: HierNavViewStyle, @ViewBuilder root: @escaping () -> Root) {
        self.style = style
        self.root = root
        model.push(view: AnyView(root()), colCount: style.colCount, emptyView: emptyView)
    }
    
    public var body: some View {
        GeometryReader { proxy in
            let screenWidth = proxy.size.width
            let realCol = min(self.style.colCount, Int(screenWidth / self.style.minWidth), maxSupportedColumns)
            
            switch realCol {
            case 1:
                NavigationStack {
                    model.getView(0, emptyView: emptyView)
                }
                .environmentObject(model)
                
            case 2:
                NavigationSplitView {
                    HierNavContainer(position: 0, subject: model.views[0])
                } detail: {
                    HierNavContainer(position: 1, subject: model.views[1])
                }
                .environmentObject(model)
                
            case 3:
                NavigationSplitView {
                    HierNavContainer(position: 0, subject: model.views[0])
                } content: {
                    HierNavContainer(position: 1, subject: model.views[1])
                } detail: {
                    HierNavContainer(position: 2, subject: model.views[2])
                }
                .environmentObject(model)
                
            default:
                HStack(alignment: .top, spacing: 0) {
                    ForEach(model.views.indices, id: \.self) { columnIndex in
                        HierNavContainer(position: columnIndex, subject: model.views[columnIndex])
                    }
                }
                .environmentObject(model)
            }
        }
    }
}