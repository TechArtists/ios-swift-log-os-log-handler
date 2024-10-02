//
//  LogPrivacy.swift
//  TALogger
//
//  Created by Robert Tataru on 01.10.2024.
//

public enum LogPrivacy: Equatable, Sendable {
    public enum Mask: Equatable, Sendable {
        case hash
        case none
    }
    
    case `public`
    case `private`(mask: Mask = .none)
    
    #if DEBUG
    nonisolated(unsafe) internal static var disableRedaction: Bool = true
    #endif
    
    internal static let redacted: String = "<redacted>"
    
    /// Returns the string representation of the value based on the privacy settings.
    ///
    /// - Parameter value: The value to be processed.
    /// - Returns: A string that is either the original value, its hash, or a redacted placeholder.
    public func value(for value: Any) -> String {
        #if DEBUG
        if Self.disableRedaction {
            return String(describing: value)
        }
        #endif
        
        switch self {
        case .public:
            return String(describing: value)
        case .private(let mask):
            switch mask {
            case .hash:
                return "\(String(describing: value).hash)"
            case .none:
                return Self.redacted
            }
        }
    }
}
