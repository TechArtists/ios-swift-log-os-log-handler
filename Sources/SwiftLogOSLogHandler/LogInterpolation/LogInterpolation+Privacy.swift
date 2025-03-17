/*
MIT License

Copyright (c) 2025 Tech Artists Agency

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

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
