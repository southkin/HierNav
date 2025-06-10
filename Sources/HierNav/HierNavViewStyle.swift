//
//  HierNavViewStyle.swift
//  HierNav
//
//  Created by kin on 5/30/25.
//


import Foundation
public enum PlatformType {
    case mac
    case iOS
    case tv
    case watch
    case vision
    case unknown

    public static var current: PlatformType {
        #if os(macOS)
        return .mac
        #elseif os(iOS)
        return .iOS
        #elseif os(tvOS)
        return .tv
        #elseif os(watchOS)
        return .watch
        #elseif os(visionOS)
        return .vision
        #else
        return .unknown
        #endif
    }
}

public enum HierNavViewStyle {
    public enum PlatformOption: Hashable {
        case mac(minWidth: Double)
        case iOS(minWidth: Double)
    }

    case single
    case split2Columns(Set<PlatformOption>)
    case split3Columns(Set<PlatformOption>)

    public func colCount(viewWidth: CGFloat) -> Int {
        switch PlatformType.current {
        case .mac, .iOS:
            switch self {
            case .single:
                return 1
            case .split2Columns(_),
                 .split3Columns(_):
                let cnt = viewWidth / minWidth
                return min(Int(cnt), maxCount)
            }
        default:
            return 1
        }
        
    }

    public var maxCount: Int {
        switch self {
        case .single: return 1
        case .split2Columns: return 2
        case .split3Columns: return 3
        }
    }
    func getOption(_ options: Set<PlatformOption>) -> PlatformOption? {
        let option = options.filter {
            switch $0 {
                case .mac(let minWidth):
                return PlatformType.current == .mac && minWidth > 0
            case .iOS(let minWidth):
                return PlatformType.current == .iOS && minWidth > 0
            }
        }
        return option.first
    }
    public var minWidth:CGFloat {
        switch self {
        case .single:
            return .greatestFiniteMagnitude
        case .split2Columns(let options), .split3Columns(let options):
            switch getOption(options) {
            case .iOS(minWidth: let minWidth), .mac(minWidth: let minWidth):
                return minWidth
            default:
                return .greatestFiniteMagnitude
            }
        }
    }
}
