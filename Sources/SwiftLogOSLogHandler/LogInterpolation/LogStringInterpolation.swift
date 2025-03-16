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
//  LogStringInterpolation.swift
//  TALogger
//
//  Created by Robert Tataru on 01.10.2024.
//
import Foundation

extension TAMessage {
    public struct LogStringInterpolation: StringInterpolationProtocol, Sendable {
        
        public enum InterpolationType : Sendable{
            case literal(String)
            case string(@Sendable () -> String, alignment: LogStringAlignment, privacy: LogPrivacy)
            case stringConvertible(@Sendable () -> CustomStringConvertible, alignment: LogStringAlignment, privacy: LogPrivacy)
            case signedInt(@Sendable () -> Int64, format: LogIntegerFormatting, alignment: LogStringAlignment, privacy: LogPrivacy)
            case unsignedInt(@Sendable () -> UInt64, format: LogIntegerFormatting, alignment: LogStringAlignment, privacy: LogPrivacy)
            case double(@Sendable () -> Double, format: LogFloatFormatting, alignment: LogStringAlignment, privacy: LogPrivacy)
            case bool(@Sendable () -> Bool, format: LogBoolFormatting, privacy: LogPrivacy)
            case float(@Sendable () -> Float, format: LogFloatFormatting, alignment: LogStringAlignment, privacy: LogPrivacy)
        }
       
        private(set) var storage: [InterpolationType] = []
        
        public mutating func addInterpolationType(_ type: InterpolationType) {
            storage.append(type)
        }
        
        public init(literalCapacity: Int, interpolationCount: Int) {}
        
        public mutating func appendLiteral(_ literal: String) {
            storage.append(.literal(literal))
        }
    }
}
