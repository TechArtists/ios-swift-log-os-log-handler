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
