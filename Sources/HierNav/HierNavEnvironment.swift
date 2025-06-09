//
//  HierNavEnvironment.swift
//  HierNav
//
//  Created by kin on 5/30/25.
//

import SwiftUI

struct HierNavViewKey: EnvironmentKey {
    static let defaultValue: HierNavModel? = nil
}
extension EnvironmentValues {
    public var hierNavView: HierNavModel? {
        get { self[HierNavViewKey.self] }
        set { self[HierNavViewKey.self] = newValue }
    }
}

struct HierNavSection: EnvironmentKey {
    static let defaultValue: Int? = nil
}
extension EnvironmentValues {
    public var hierNavSection: Int? {
        get { self[HierNavSection.self] }
        set { self[HierNavSection.self] = newValue }
    }
}
