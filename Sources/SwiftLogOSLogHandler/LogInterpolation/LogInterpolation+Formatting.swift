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
