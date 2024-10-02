import Foundation
import Logging
import struct Logging.Logger
import os

public struct SwiftLogOSLogHandler: LogHandler {
    public var logLevel: Logger.Level = .trace
    public let label: String
    
    private let osLogger: os.Logger
    
    public init(label: String) {
        self.label = label
        let bundleIdentifier = Bundle.main.bundleIdentifier ?? ""
        self.osLogger = os.Logger(subsystem: bundleIdentifier, category: label)
    }

    public init(label: String, osLogger: os.Logger) {
        self.label = label
        self.osLogger = osLogger
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
        
        osLogger.log(
            level: OSLogType.from(loggerLevel: level),
            "\(formedMessage) [File: \(file), Function: \(function), Line: \(line)]"
        )
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
