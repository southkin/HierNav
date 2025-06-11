//
//  HierNavContainer.swift
//  HierNav
//
//  Created by kin on 5/30/25.
//

import SwiftUI
import Combine

public struct HierNavContainer: View {
    enum Mode { case single, stack }
    
    let mode: Mode
    @StateObject private var model: HierNavContainerModel
    
    @Environment(\.hierNavView) private var navModel
    
    init(mode: Mode, stream: CurrentValueSubject<[AnyView], Never>) {
        self.mode = mode
        self._model = StateObject(wrappedValue:.init(stream: stream) )
    }
    
    public var body: some View {
        switch mode {
        case .single:
            model.views.first
        case .stack:
            NavigationStack(path: $model.path) {
                let first = model.views.first
                first?.navigationDestination(for: Int.self) { index in
                    if index < model.views.count {
                        model.views[index]
                    } else {
                        Text("❌").toAnyView
                    }
                }
            }
            .onChange(of: model.path) {
                guard model.isPushed == false else {
                    model.isPushed = false
                    return
                }
                let cnt = model.views.count - 1 - model.path.count
                if cnt > 0 {
                    model.views.removeLast(cnt)
                    navModel?.poppedView(cnt: cnt)
                }
            }
        }
    }
}
