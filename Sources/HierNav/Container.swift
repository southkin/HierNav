//
//  Container.swift
//  HierNav
//
//  Created by kin on 5/15/25.
//

import SwiftUI
import Combine

class HierNavContainerModel: ObservableObject {
    @Published var content: HierNavContentType = .single(AnyView(EmptyView()))
    private var cancellables = Set<AnyCancellable>()
    
    init(subject: CurrentValueSubject<HierNavContentType, Never>) {
        subject.sink { views in
            self.content = views
        }
        .store(in: &cancellables)
    }
}

public struct HierNavContainer: View {
    @StateObject private var model: HierNavContainerModel
    @State private var path = NavigationPath()
    var position: Int
    
    init(position: Int, subject:CurrentValueSubject<HierNavContentType, Never>) {
        self.position = position
        _model = StateObject(wrappedValue: HierNavContainerModel(subject: subject))
    }
    
    public var body: some View {
        switch model.content {
        case .single(let view):
            AnyView(view)
            
        case .stack(let views):
            NavigationStack(path: $path) {
                // 🌱 루트는 첫 번째, 나머지는 path로 관리
                AnyView(views[0])
                    .navigationDestination(for: AnyHashable.self) { item in
                        if let index = item as? Int, index < views.count {
                            views[index]
                        } else {
                            AnyView(Text("잘못된 경로"))
                        }
                    }
            }
            .onAppear {
                // 🧩 스택에 히스토리 채워주기
                path = NavigationPath((1..<views.count).map { $0 })
            }
        }
    }
}