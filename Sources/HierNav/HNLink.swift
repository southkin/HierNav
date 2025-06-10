//
//  HNLink.swift
//  HierNav
//
//  Created by kin on 5/16/25.
//
import SwiftUI


public struct HNLink<Label: View, Destination: View>: View {
    private let actionType: HNType
    private let label: () -> Label
    private let destination: () -> Destination
    @Environment(\.hierNavView) private var navModel
    @Environment(\.hierNavSection) private var section
    @State private var isPresentingModal = false
    @State private var isPresentingPopover = false
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
        #if os(iOS) || os(macOS) || targetEnvironment(macCatalyst)
        .popover(isPresented: $isPresentingPopover) {
            destination()
        }
        #endif
    }
    private func performAction() {
#if os(watchOS)
        pushView()
        return
#else
        switch actionType {
        case .push:
            pushView()
        case .present:
            presentView()
        case .popover:
            showPopover()
        }
#endif
    }
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
    private func presentView() {
        isPresentingModal = true
    }
    private func showPopover() {
        isPresentingPopover = true
    }
}

// MARK: - Convenience Initializers

extension HNLink where Label == Text {
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
