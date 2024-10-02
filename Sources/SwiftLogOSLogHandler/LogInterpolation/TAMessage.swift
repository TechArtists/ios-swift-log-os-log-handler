//
//  TAMessage.swift
//  TALogger
//
//  Created by Robert Tataru on 01.10.2024.
//

import Foundation

public struct TAMessage: ExpressibleByStringInterpolation, ExpressibleByStringLiteral, CustomStringConvertible, Sendable {
   
    var logStringInterpolation: LogStringInterpolation
    
    public init(stringLiteral value: String) {
        self.logStringInterpolation = .init(literalCapacity: 0, interpolationCount: 0)
        self.logStringInterpolation.appendLiteral(value)
        
    }
    
    public init(stringInterpolation: LogStringInterpolation) {
        self.logStringInterpolation = stringInterpolation
    }
    
    public var description: String {
        logStringInterpolation.storage.reduce(into: "") { message, value in
            message += process(value)
        }
    }

    private func process(_ value: LogStringInterpolation.InterpolationType) -> String {
        switch value {
        case .literal(let text):
            return text
        case .bool(let getter, let format, let privacy):
            return privacy.value(for: formatBool(getter(), format))
        case .stringConvertible(let getter, let alignment, let privacy):
            let processedString = privacy.value(for: getter().description)
            return applyAlignment(processedString, alignment: alignment)
        case .double(let getter, let format, let alignment, let privacy):
            let processedDouble = privacy.value(for: formatNumber(getter(), format))
            return applyAlignment(processedDouble, alignment: alignment)
        case .float(let getter, let format, let alignment, let privacy):
            let processedFloat = privacy.value(for: formatNumber(Double(getter()), format))
            return applyAlignment(processedFloat, alignment: alignment)
        case .signedInt(let getter, let format, let alignment, let privacy):
            let processedSignedInt = privacy.value(for: formatSignedInt(getter(), format))
            return applyAlignment(processedSignedInt, alignment: alignment)
        case .unsignedInt(let getter, let format, let alignment, let privacy):
            let processedUnsignedInt = privacy.value(for: formatUnsignedInt(getter(), format))
            return applyAlignment(processedUnsignedInt, alignment: alignment)
        case .string(let getter, let alignment, let privacy):
            let processedString =  privacy.value(for: getter())
            return applyAlignment(processedString, alignment: alignment)
        }
    }
    
    private func applyAlignment(_ string: String, alignment: LogStringAlignment) -> String {
        switch alignment {
        case .left(let columns):
            return alignLeft(string, columns: columns)
        case .right(let columns):
            return alignRight(string, columns: columns)
        case .none:
            return string
        }
    }

    private func alignLeft(_ string: String, columns: Int) -> String {
        if string.count > columns {
            // Truncate the string to fit the columns
            return String(string.prefix(columns))
        } else {
            // Pad spaces to the right
            let padding = String(repeating: " ", count: columns - string.count)
            return string + padding
        }
    }

    private func alignRight(_ string: String, columns: Int) -> String {
        if string.count > columns {
            // Truncate the string to fit the columns
            return String(string.prefix(columns))
        } else {
            // Pad spaces to the left
            let padding = String(repeating: " ", count: columns - string.count)
            return padding + string
        }
    }

    private func formatBool(_ value: Bool, _ format: LogBoolFormatting) -> String {
        switch format {
        case .answer:
            return value ? "yes" : "no"
        case .truth:
            return value ? "true" : "false"
        }
    }

    private func formatNumber(_ value: Double, _ format: LogFloatFormatting) -> String {
        switch format {
        case let .fixed(precision, explicitPositiveSign):
            return String(format: "\(explicitPositiveSign ? "+" : "")%.0\(precision)f", value)
        }
    }

    private func formatSignedInt(_ value: Int64, _ format: LogIntegerFormatting) -> String {
        switch format {
        case let .decimal(minDigits, explicitPositiveSign):
            return String(format: "\(explicitPositiveSign ? "+" : "")%0\(minDigits)ld", value)
        }
    }

    private func formatUnsignedInt(_ value: UInt64, _ format: LogIntegerFormatting) -> String {
        switch format {
        case let .decimal(minDigits, explicitPositiveSign):
            return String(format: "\(explicitPositiveSign ? "+" : "")%0\(minDigits)lu", value)
        }
    }
}
