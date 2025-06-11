//
//  HierNavContainerModel.swift
//  HierNav
//
//  Created by kin on 5/30/25.
//

import SwiftUI
import Combine

@MainActor
class HierNavContainerModel: ObservableObject {
    let stream: CurrentValueSubject<[AnyView], Never>
    private var cancellables = Set<AnyCancellable>()
    
    @Published var views: [AnyView] = []
    @Published var path = NavigationPath()
    var isPushed: Bool = false
    var isColChanged: Bool = false
    init(stream: CurrentValueSubject<[AnyView], Never>) {
        self.stream = stream
        self.stream.sink { [weak self] new in
            guard let self = self else {return}
            self.views = new
            isPushed = true
            if views.count > 1 {
                path = NavigationPath((1..<views.count).map { $0 })
            } else {
                path = NavigationPath()
            }
        }
        .store(in: &cancellables)
    }
    
}
