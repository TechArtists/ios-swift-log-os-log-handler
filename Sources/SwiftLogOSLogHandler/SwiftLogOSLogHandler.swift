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

import Foundation
import Logging
import struct Logging.Logger
import os

public struct SwiftLogOSLogHandler: LogHandler {
    public var logLevel: Logger.Level = .trace
    public let label: String
    public let shouldLogCallsiteMetadata: Bool
    
    private let osLogger: os.Logger
    
    public init(label: String, shouldLogCallsiteMetadata: Bool = false) {
        self.label = label
        let bundleIdentifier = Bundle.main.bundleIdentifier ?? ""
        self.osLogger = os.Logger(subsystem: bundleIdentifier, category: label)
        self.shouldLogCallsiteMetadata = shouldLogCallsiteMetadata
    }

    public init(label: String, osLogger: os.Logger, shouldLogCallsiteMetadata: Bool = false) {
        self.label = label
        self.osLogger = osLogger
        self.shouldLogCallsiteMetadata = shouldLogCallsiteMetadata
    }
    
    public func log(
        level: Logger.Level,
        message: Logger.Message,
        metadata: Logger.Metadata?,
        source: String,
        file: String,
        function: String,
        line: UInt
    ) {
        var combinedPrettyMetadata = self.prettyMetadata
        if let metadataOverride = metadata, !metadataOverride.isEmpty {
            combinedPrettyMetadata = self.prettify(
                self.metadata.merging(metadataOverride) {
                    return $1
                }
            )
        }
        
        var formedMessage = message.description
        
        if let combinedPrettyMetadata {
            formedMessage += " -- " + combinedPrettyMetadata
        }
        
        addCallSiteMetadataIfNecessary(to: &formedMessage, file: file, function: function, line: line)
        
        osLogger.log(
            level: OSLogType.from(loggerLevel: level),
            "\(formedMessage) "
        )
    }
    
    private func addCallSiteMetadataIfNecessary(
        to message: inout String,
        file: String,
        function: String,
        line: UInt
    ) {
        let callSiteMetadata = "[File: \(file), Function: \(function), Line: \(line)]"
        
        if shouldLogCallsiteMetadata {
            message += " \(callSiteMetadata)"
        }
    }
    
    private var prettyMetadata: String?
    
    public var metadata = Logger.Metadata() {
        didSet {
            self.prettyMetadata = self.prettify(self.metadata)
        }
    }
    
    /// Add, remove, or change the logging metadata.
    /// - parameters:
    ///    - metadataKey: the key for the metadata item.
    public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get {
            return self.metadata[metadataKey]
        }
        set {
            self.metadata[metadataKey] = newValue
        }
    }
    
    private func prettify(_ metadata: Logger.Metadata) -> String? {
        if metadata.isEmpty {
            return nil
        }
        return metadata.map {
            "\($0)=\($1)"
        }.joined(separator: " ")
    }
}

extension OSLogType {
    static func from(loggerLevel: Logger.Level) -> Self {
        switch loggerLevel {
        case .trace:
            /// `OSLog` doesn't have `trace`, so use `debug`
            return .debug
        case .debug:
            return .debug
        case .info:
            return .info
        case .notice:
            // https://developer.apple.com/documentation/os/logging/generating_log_messages_from_your_code
            // According to the documentation, `default` is `notice`.
            return .default
        case .warning:
            /// `OSLog` doesn't have `warning`, so use `info`
            return .info
        case .error:
            return .error
        case .critical:
            return .fault
        }
    }
}
