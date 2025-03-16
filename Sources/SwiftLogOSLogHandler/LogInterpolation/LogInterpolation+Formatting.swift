//
//  LogInterpolation+Formatting.swift
//  TALogger
//
//  Created by Robert Tataru on 01.10.2024.
//


public enum LogBoolFormatting: Sendable {
    /// Displays an interpolated boolean value as true or false.
    case truth
    /// Displays an interpolated boolean value as yes or no.
    case answer
}

public enum LogStringAlignment: Sendable {
    case none
    case left(columns: Int)
    case right(columns:  Int)
}

public enum LogFloatFormatting: Sendable {
    case fixed(precision: Int, explicitPositiveSign: Bool)
    
    public static func fixed(explicitPositiveSign: Bool = false, precision: Int = 6) -> LogFloatFormatting {
        .fixed(precision: precision, explicitPositiveSign: explicitPositiveSign)
    }
}

public enum LogIntegerFormatting: Sendable {
    case decimal(minDigits: Int, explicitPositiveSign: Bool)
    
    public static func decimal(explicitPositiveSign: Bool = false, minDigits: Int = 0) -> Self {
        .decimal(minDigits: minDigits, explicitPositiveSign: explicitPositiveSign)
    }
}
