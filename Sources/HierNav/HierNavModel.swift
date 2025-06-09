//
//  HierNavModel.swift
//  HierNav
//
//  Created by kin on 5/30/25.
//

import SwiftUI
import Combine
import KinKit

@MainActor
public class HierNavModel: ObservableObject {
    var style: HierNavViewStyle
    var viewWidth: CGFloat = 0
    @Published var currentColumnCount: Int = 0
    var views: [AnyView]
    @Published var viewStreams: [CurrentValueSubject<[AnyView], Never>] = .init()
    init(style: HierNavViewStyle, root: AnyView) {
        self.style = style
        views = [root]
        updateViewWidth(1, sizeClass: nil)
    }
    func getView(index:Int) -> AnyView? {
        guard views.count > index else { return nil }
        return views[index]
    }
    func getViews(range:PartialRangeFrom<Int>) -> [AnyView] {
        guard views.count > range.lowerBound else { return [] }
        return Array(views[range])
    }
    func updateViewWidth(_ width: CGFloat, sizeClass: UserInterfaceSizeClass?) {
        DispatchQueue.main.async { [self] in
            self.viewWidth = width
            let cnt: Int
            if PlatformType.current == .iOS, sizeClass == .compact {
                cnt = 1
            }
            else {
                cnt = max(1, min(Int(self.viewWidth / self.style.minWidth), self.style.maxCount))
            }
            guard cnt != self.currentColumnCount else { return }
            self.viewStreams = (0..<cnt).map { _ in CurrentValueSubject<[AnyView], Never>([]) }
            for i in 0..<cnt {
                guard self.views.count == i+1 else {
                    self.viewStreams[i].send(self.getViews(range: i...))
                    break
                }
                self.viewStreams[i].send([self.getView(index: i)].compactMap{$0})
            }
            self.currentColumnCount = cnt
        }
    }
    func poppedView(cnt:Int = 1) {
        views.removeLast(cnt)
    }
    func addView(view: AnyView, at index: Int) {
        guard index <= currentColumnCount else {
            print("⚠️ addView 실패: 유효하지 않은 컬럼 인덱스 \(index)")
            return
        }
        if index < currentColumnCount-1 {
            views = Array(views.prefix(index+1))
        }
        views.append(view)
        for i in index..<currentColumnCount {
            if i == currentColumnCount - 1 {
                viewStreams[i].send(getViews(range: i...))
            } else {
                viewStreams[i].send([getView(index: i)].compactMap{$0})
            }
        }
    }
    func addView(view:some View) {
        let content = view.toAnyView
        views.append(content)
        let idx = min(views.count, currentColumnCount-1)
        let viewStream = viewStreams[idx]
        switch idx {
        case currentColumnCount-1:
            var newList = viewStream.value
            newList.append(content)
            viewStream.send(newList)
            break
        default:
            viewStream.send([content])
            break
        }
    }
}
