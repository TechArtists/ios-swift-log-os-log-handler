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
