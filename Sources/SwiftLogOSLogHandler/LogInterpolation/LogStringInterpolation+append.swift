/*
MIT License

Copyright (c) 2025 Tataru Robert

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
//  Untitled.swift
//  TALogger
//
//  Created by Robert Tataru on 01.10.2024.
//

public extension TAMessage.LogStringInterpolation {
    public mutating func appendInterpolation(_ argumentString: @Sendable @autoclosure @escaping () -> String, align: LogStringAlignment = .none, privacy: LogPrivacy = .private()) {
        addInterpolationType(.string(argumentString, alignment: align, privacy: privacy))
    }
    
    public mutating func appendInterpolation<T>(_ value: @Sendable @autoclosure @escaping () -> T, align: LogStringAlignment = .none, privacy: LogPrivacy = .private()) where T: CustomStringConvertible {
        addInterpolationType(.stringConvertible(value, alignment: align, privacy: privacy))
    }
    
    public mutating func appendInterpolation<T: SignedInteger>(_ number: @Sendable @autoclosure @escaping () -> T, format: LogIntegerFormatting = .decimal(), align: LogStringAlignment = .none, privacy: LogPrivacy = .private()) {
        addInterpolationType(.signedInt({ Int64(number()) }, format: format, alignment: align, privacy: privacy))
    }

    public mutating func appendInterpolation<T: UnsignedInteger>(_ number: @Sendable @autoclosure @escaping () -> T, format: LogIntegerFormatting = .decimal(), align: LogStringAlignment = .none, privacy: LogPrivacy = .private()) {
        addInterpolationType(.unsignedInt({ UInt64(number()) }, format: format, alignment: align, privacy: privacy))
    }
    
    public mutating func appendInterpolation(_ number: @Sendable @autoclosure @escaping () -> Float, format: LogFloatFormatting = .fixed(), align: LogStringAlignment = .none, privacy: LogPrivacy = .private()) {
        addInterpolationType(.float(number, format: format, alignment: align, privacy: privacy))
    }
    
    public mutating func appendInterpolation(_ number: @Sendable @autoclosure @escaping () -> Double, format: LogFloatFormatting = .fixed(), align: LogStringAlignment = .none, privacy: LogPrivacy = .private()) {
        addInterpolationType(.double(number, format: format, alignment: align, privacy: privacy))
    }
    
    public mutating func appendInterpolation(_ boolean: @Sendable @autoclosure @escaping () -> Bool, format: LogBoolFormatting = .truth, privacy: LogPrivacy = .private()) {
        addInterpolationType(.bool(boolean, format: format, privacy: privacy))
    }
}
