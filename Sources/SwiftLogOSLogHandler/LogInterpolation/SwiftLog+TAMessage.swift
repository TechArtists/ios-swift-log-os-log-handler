//
//  SwiftLog+TAMessage.swift
//  TALogger
//
//  Created by Robert Tataru on 01.10.2024.
//

import Logging

extension Logger.Message {
    public init(from taMessage: TAMessage) {
        self.init(stringLiteral: taMessage.description)
    }
}

extension Logger {
    
    #if compiler(>=5.3)
    /// Log a message passing the log level as a parameter.
    ///
    /// If the `logLevel` passed to this method is more severe than the `Logger`'s ``logLevel``, it will be logged,
    /// otherwise nothing will happen.
    ///
    /// - parameters:
    ///    - level: The log level to log `message` at. For the available log levels, see `Logger.Level`.
    ///    - message: The message to be logged. `message` can be used with any string interpolation literal.
    ///    - metadata: One-off metadata to attach to this log message.
    ///    - source: The source this log messages originates from. Defaults
    ///              to the module emitting the log message (on Swift 5.3 or
    ///              newer and the folder name containing the log emitting file on Swift 5.2 or
    ///              older).
    ///    - file: The file this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#fileID` (on Swift 5.3 or newer and `#file` on Swift 5.2 or older).
    ///    - function: The function this log message originates from (there's usually no need to pass it explicitly as
    ///                it defaults to `#function`).
    ///    - line: The line this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#line`).
    @inlinable
    public func log(level: Logger.Level,
                    taMessage: @autoclosure () -> TAMessage,
                    metadata: @autoclosure () -> Logger.Metadata? = nil,
                    source: @autoclosure () -> String? = nil,
                    file: String = #fileID, function: String = #function, line: UInt = #line) {
        if self.logLevel <= level {
            self.handler.log(level: level,
                             message: Message(from: taMessage()),
                             metadata: metadata(),
                             source: source() ?? Logger.currentModule(fileID: (file)),
                             file: file, function: function, line: line)
        }
    }

    #else
    @inlinable
    public func log(level: Logger.Level,
                    taMessage: @autoclosure () -> TAMessage,
                    metadata: @autoclosure () -> Logger.Metadata? = nil,
                    source: @autoclosure () -> String? = nil,
                    file: String = #file, function: String = #function, line: UInt = #line) {
        if self.logLevel <= level {
            self.handler.log(level: level,
                             message: Message(from: message()),
                             metadata: metadata(),
                             source: source() ?? Logger.currentModule(filePath: (file)),
                             file: file, function: function, line: line)
        }
    }
    #endif
    
    /// Log a message passing the log level as a parameter.
    ///
    /// If the ``logLevel`` passed to this method is more severe than the `Logger`'s ``logLevel``, it will be logged,
    /// otherwise nothing will happen.
    ///
    /// - parameters:
    ///    - level: The log level to log `message` at. For the available log levels, see `Logger.Level`.
    ///    - message: The message to be logged. `message` can be used with any string interpolation literal.
    ///    - metadata: One-off metadata to attach to this log message.
    ///    - file: The file this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#fileID` (on Swift 5.3 or newer and `#file` on Swift 5.2 or older).
    ///    - function: The function this log message originates from (there's usually no need to pass it explicitly as
    ///                it defaults to `#function`).
    ///    - line: The line this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#line`).
    #if compiler(>=5.3)
    @inlinable
    public func log(level: Logger.Level,
                    taMessage: @autoclosure () -> TAMessage,
                    metadata: @autoclosure () -> Logger.Metadata? = nil,
                    file: String = #fileID, function: String = #function, line: UInt = #line) {
        self.log(level: level, taMessage: taMessage(), metadata: metadata(), source: nil, file: file, function: function, line: line)
    }

    #else
    @inlinable
    public func log(level: Logger.Level,
                    taMessage: @autoclosure () -> TAMessage,
                    metadata: @autoclosure () -> Logger.Metadata? = nil,
                    file: String = #file, function: String = #function, line: UInt = #line) {
        self.log(level: level, taMessage(), metadata: metadata(), source: nil, file: file, function: function, line: line)
    }
    #endif
    
}

extension Logger {
    /// Log a message passing with the ``Logger/Level/trace`` log level.
    ///
    /// If `.trace` is at least as severe as the `Logger`'s ``logLevel``, it will be logged,
    /// otherwise nothing will happen.
    ///
    /// - parameters:
    ///    - message: The message to be logged. `message` can be used with any string interpolation literal.
    ///    - metadata: One-off metadata to attach to this log message
    ///    - source: The source this log messages originates from. Defaults
    ///              to the module emitting the log message (on Swift 5.3 or
    ///              newer and the folder name containing the log emitting file on Swift 5.2 or
    ///              older).
    ///    - file: The file this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#fileID` (on Swift 5.3 or newer and `#file` on Swift 5.2 or older).
    ///    - function: The function this log message originates from (there's usually no need to pass it explicitly as
    ///                it defaults to `#function`).
    ///    - line: The line this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#line`).
    #if compiler(>=5.3)
    @inlinable
    public func trace(taMessage: @autoclosure () -> TAMessage,
                      metadata: @autoclosure () -> Logger.Metadata? = nil,
                      source: @autoclosure () -> String? = nil,
                      file: String = #fileID, function: String = #function, line: UInt = #line) {
        self.log(level: .trace, taMessage: taMessage(), metadata: metadata(), source: source(), file: file, function: function, line: line)
    }

    #else
    @inlinable
    public func trace(taMessage: @autoclosure () -> TAMessage,
                      metadata: @autoclosure () -> Logger.Metadata? = nil,
                      source: @autoclosure () -> String? = nil,
                      file: String = #file, function: String = #function, line: UInt = #line) {
        self.log(level: .trace, message(), metadata: metadata(), source: source(), file: file, function: function, line: line)
    }
    #endif

    /// Log a message passing with the ``Logger/Level/trace`` log level.
    ///
    /// If `.trace` is at least as severe as the `Logger`'s ``logLevel``, it will be logged,
    /// otherwise nothing will happen.
    ///
    /// - parameters:
    ///    - message: The message to be logged. `message` can be used with any string interpolation literal.
    ///    - metadata: One-off metadata to attach to this log message
    ///    - file: The file this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#fileID` (on Swift 5.3 or newer and `#file` on Swift 5.2 or older).
    ///    - function: The function this log message originates from (there's usually no need to pass it explicitly as
    ///                it defaults to `#function`).
    ///    - line: The line this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#line`).
    #if compiler(>=5.3)
    @inlinable
    public func trace(taMessage: @autoclosure () -> TAMessage,
                      metadata: @autoclosure () -> Logger.Metadata? = nil,
                      file: String = #fileID, function: String = #function, line: UInt = #line) {
        self.trace(taMessage: taMessage(), metadata: metadata(), source: nil, file: file, function: function, line: line)
    }

    #else
    @inlinable
    public func trace(taMessage: @autoclosure () -> TAMessage,
                      metadata: @autoclosure () -> Logger.Metadata? = nil,
                      file: String = #file, function: String = #function, line: UInt = #line) {
        self.trace(message(), metadata: metadata(), source: nil, file: file, function: function, line: line)
    }
    #endif

    /// Log a message passing with the ``Logger/Level/debug`` log level.
    ///
    /// If `.debug` is at least as severe as the `Logger`'s ``logLevel``, it will be logged,
    /// otherwise nothing will happen.
    ///
    /// - parameters:
    ///    - message: The message to be logged. `message` can be used with any string interpolation literal.
    ///    - metadata: One-off metadata to attach to this log message.
    ///    - source: The source this log messages originates from. Defaults
    ///              to the module emitting the log message (on Swift 5.3 or
    ///              newer and the folder name containing the log emitting file on Swift 5.2 or
    ///              older).
    ///    - file: The file this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#fileID` (on Swift 5.3 or newer and `#file` on Swift 5.2 or older).
    ///    - function: The function this log message originates from (there's usually no need to pass it explicitly as
    ///                it defaults to `#function`).
    ///    - line: The line this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#line`).
    #if compiler(>=5.3)
    @inlinable
    public func debug(taMessage: @autoclosure () -> TAMessage,
                      metadata: @autoclosure () -> Logger.Metadata? = nil,
                      source: @autoclosure () -> String? = nil,
                      file: String = #fileID, function: String = #function, line: UInt = #line) {
        self.log(level: .debug, taMessage: taMessage(), metadata: metadata(), source: source(), file: file, function: function, line: line)
    }

    #else
    @inlinable
    public func debug(taMessage: @autoclosure () -> TAMessage,
                      metadata: @autoclosure () -> Logger.Metadata? = nil,
                      source: @autoclosure () -> String? = nil,
                      file: String = #file, function: String = #function, line: UInt = #line) {
        self.log(level: .debug, message(), metadata: metadata(), source: source(), file: file, function: function, line: line)
    }
    #endif

    /// Log a message passing with the ``Logger/Level/debug`` log level.
    ///
    /// If `.debug` is at least as severe as the `Logger`'s ``logLevel``, it will be logged,
    /// otherwise nothing will happen.
    ///
    /// - parameters:
    ///    - message: The message to be logged. `message` can be used with any string interpolation literal.
    ///    - metadata: One-off metadata to attach to this log message.
    ///    - file: The file this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#fileID` (on Swift 5.3 or newer and `#file` on Swift 5.2 or older).
    ///    - function: The function this log message originates from (there's usually no need to pass it explicitly as
    ///                it defaults to `#function`).
    ///    - line: The line this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#line`).
    #if compiler(>=5.3)
    @inlinable
    public func debug(taMessage: @autoclosure () -> TAMessage,
                      metadata: @autoclosure () -> Logger.Metadata? = nil,
                      file: String = #fileID, function: String = #function, line: UInt = #line) {
        self.debug(taMessage: taMessage(), metadata: metadata(), source: nil, file: file, function: function, line: line)
    }

    #else
    @inlinable
    public func debug(taMessage: @autoclosure () -> TAMessage,
                      metadata: @autoclosure () -> Logger.Metadata? = nil,
                      file: String = #file, function: String = #function, line: UInt = #line) {
        self.debug(message(), metadata: metadata(), source: nil, file: file, function: function, line: line)
    }
    #endif

    /// Log a message passing with the ``Logger/Level/info`` log level.
    ///
    /// If `.info` is at least as severe as the `Logger`'s ``logLevel``, it will be logged,
    /// otherwise nothing will happen.
    ///
    /// - parameters:
    ///    - message: The message to be logged. `message` can be used with any string interpolation literal.
    ///    - metadata: One-off metadata to attach to this log message.
    ///    - source: The source this log messages originates from. Defaults
    ///              to the module emitting the log message (on Swift 5.3 or
    ///              newer and the folder name containing the log emitting file on Swift 5.2 or
    ///              older).
    ///    - file: The file this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#fileID` (on Swift 5.3 or newer and `#file` on Swift 5.2 or older).
    ///    - function: The function this log message originates from (there's usually no need to pass it explicitly as
    ///                it defaults to `#function`).
    ///    - line: The line this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#line`).
    #if compiler(>=5.3)
    @inlinable
    public func info(taMessage: @autoclosure () -> TAMessage,
                     metadata: @autoclosure () -> Logger.Metadata? = nil,
                     source: @autoclosure () -> String? = nil,
                     file: String = #fileID, function: String = #function, line: UInt = #line) {
        self.log(level: .info, taMessage: taMessage(), metadata: metadata(), source: source(), file: file, function: function, line: line)
    }

    #else
    @inlinable
    public func info(taMessage: @autoclosure () -> TAMessage,
                     metadata: @autoclosure () -> Logger.Metadata? = nil,
                     source: @autoclosure () -> String? = nil,
                     file: String = #file, function: String = #function, line: UInt = #line) {
        self.log(level: .info, message(), metadata: metadata(), source: source(), file: file, function: function, line: line)
    }
    #endif

    /// Log a message passing with the ``Logger/Level/info`` log level.
    ///
    /// If `.info` is at least as severe as the `Logger`'s ``logLevel``, it will be logged,
    /// otherwise nothing will happen.
    ///
    /// - parameters:
    ///    - message: The message to be logged. `message` can be used with any string interpolation literal.
    ///    - metadata: One-off metadata to attach to this log message.
    ///    - file: The file this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#fileID` (on Swift 5.3 or newer and `#file` on Swift 5.2 or older).
    ///    - function: The function this log message originates from (there's usually no need to pass it explicitly as
    ///                it defaults to `#function`).
    ///    - line: The line this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#line`).
    #if compiler(>=5.3)
    @inlinable
    public func info(taMessage: @autoclosure () -> TAMessage,
                     metadata: @autoclosure () -> Logger.Metadata? = nil,
                     file: String = #fileID, function: String = #function, line: UInt = #line) {
        self.info(taMessage: taMessage(), metadata: metadata(), source: nil, file: file, function: function, line: line)
    }

    #else
    @inlinable
    public func info(taMessage: @autoclosure () -> TAMessage,
                     metadata: @autoclosure () -> Logger.Metadata? = nil,
                     file: String = #file, function: String = #function, line: UInt = #line) {
        self.info(message(), metadata: metadata(), source: nil, file: file, function: function, line: line)
    }
    #endif

    /// Log a message passing with the ``Logger/Level/notice`` log level.
    ///
    /// If `.notice` is at least as severe as the `Logger`'s ``logLevel``, it will be logged,
    /// otherwise nothing will happen.
    ///
    /// - parameters:
    ///    - message: The message to be logged. `message` can be used with any string interpolation literal.
    ///    - metadata: One-off metadata to attach to this log message.
    ///    - source: The source this log messages originates from. Defaults
    ///              to the module emitting the log message (on Swift 5.3 or
    ///              newer and the folder name containing the log emitting file on Swift 5.2 or
    ///              older).
    ///    - file: The file this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#fileID` (on Swift 5.3 or newer and `#file` on Swift 5.2 or older).
    ///    - function: The function this log message originates from (there's usually no need to pass it explicitly as
    ///                it defaults to `#function`).
    ///    - line: The line this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#line`).
    #if compiler(>=5.3)
    @inlinable
    public func notice(taMessage: @autoclosure () -> TAMessage,
                       metadata: @autoclosure () -> Logger.Metadata? = nil,
                       source: @autoclosure () -> String? = nil,
                       file: String = #fileID, function: String = #function, line: UInt = #line) {
        self.log(level: .notice, taMessage: taMessage(), metadata: metadata(), source: source(), file: file, function: function, line: line)
    }

    #else
    @inlinable
    public func notice(taMessage: @autoclosure () -> TAMessage,
                       metadata: @autoclosure () -> Logger.Metadata? = nil,
                       source: @autoclosure () -> String? = nil,
                       file: String = #file, function: String = #function, line: UInt = #line) {
        self.log(level: .notice, message(), metadata: metadata(), source: source(), file: file, function: function, line: line)
    }
    #endif

    /// Log a message passing with the ``Logger/Level/notice`` log level.
    ///
    /// If `.notice` is at least as severe as the `Logger`'s ``logLevel``, it will be logged,
    /// otherwise nothing will happen.
    ///
    /// - parameters:
    ///    - message: The message to be logged. `message` can be used with any string interpolation literal.
    ///    - metadata: One-off metadata to attach to this log message.
    ///    - source: The source this log messages originates from. Defaults
    ///              to the module emitting the log message (on Swift 5.3 or
    ///              newer and the folder name containing the log emitting file on Swift 5.2 or
    ///              older).
    ///    - file: The file this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#fileID` (on Swift 5.3 or newer and `#file` on Swift 5.2 or older).
    ///    - function: The function this log message originates from (there's usually no need to pass it explicitly as
    ///                it defaults to `#function`).
    ///    - line: The line this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#line`).
    #if compiler(>=5.3)
    @inlinable
    public func notice(taMessage: @autoclosure () -> TAMessage,
                       metadata: @autoclosure () -> Logger.Metadata? = nil,
                       file: String = #fileID, function: String = #function, line: UInt = #line) {
        self.notice(taMessage: taMessage(), metadata: metadata(), source: nil, file: file, function: function, line: line)
    }

    #else
    @inlinable
    public func notice(taMessage: @autoclosure () -> TAMessage,
                       metadata: @autoclosure () -> Logger.Metadata? = nil,
                       file: String = #file, function: String = #function, line: UInt = #line) {
        self.notice(message(), metadata: metadata(), source: nil, file: file, function: function, line: line)
    }
    #endif

    /// Log a message passing with the ``Logger/Level/warning`` log level.
    ///
    /// If `.warning` is at least as severe as the `Logger`'s ``logLevel``, it will be logged,
    /// otherwise nothing will happen.
    ///
    /// - parameters:
    ///    - message: The message to be logged. `message` can be used with any string interpolation literal.
    ///    - metadata: One-off metadata to attach to this log message.
    ///    - source: The source this log messages originates from. Defaults
    ///              to the module emitting the log message (on Swift 5.3 or
    ///              newer and the folder name containing the log emitting file on Swift 5.2 or
    ///              older).
    ///    - file: The file this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#fileID` (on Swift 5.3 or newer and `#file` on Swift 5.2 or older).
    ///    - function: The function this log message originates from (there's usually no need to pass it explicitly as
    ///                it defaults to `#function`).
    ///    - line: The line this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#line`).
    #if compiler(>=5.3)
    @inlinable
    public func warning(taMessage: @autoclosure () -> TAMessage,
                        metadata: @autoclosure () -> Logger.Metadata? = nil,
                        source: @autoclosure () -> String? = nil,
                        file: String = #fileID, function: String = #function, line: UInt = #line) {
        self.log(level: .warning, taMessage: taMessage(), metadata: metadata(), source: source(), file: file, function: function, line: line)
    }

    #else
    @inlinable
    public func warning(taMessage: @autoclosure () -> TAMessage,
                        metadata: @autoclosure () -> Logger.Metadata? = nil,
                        source: @autoclosure () -> String? = nil,
                        file: String = #file, function: String = #function, line: UInt = #line) {
        self.log(level: .warning, message(), metadata: metadata(), source: source(), file: file, function: function, line: line)
    }
    #endif

    /// Log a message passing with the ``Logger/Level/warning`` log level.
    ///
    /// If `.warning` is at least as severe as the `Logger`'s ``logLevel``, it will be logged,
    /// otherwise nothing will happen.
    ///
    /// - parameters:
    ///    - message: The message to be logged. `message` can be used with any string interpolation literal.
    ///    - metadata: One-off metadata to attach to this log message.
    ///    - file: The file this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#fileID` (on Swift 5.3 or newer and `#file` on Swift 5.2 or older).
    ///    - function: The function this log message originates from (there's usually no need to pass it explicitly as
    ///                it defaults to `#function`).
    ///    - line: The line this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#line`).
    #if compiler(>=5.3)
    @inlinable
    public func warning(taMessage: @autoclosure () -> TAMessage,
                        metadata: @autoclosure () -> Logger.Metadata? = nil,
                        file: String = #fileID, function: String = #function, line: UInt = #line) {
        self.warning(taMessage: taMessage(), metadata: metadata(), source: nil, file: file, function: function, line: line)
    }

    #else
    @inlinable
    public func warning(taMessage: @autoclosure () -> TAMessage,
                        metadata: @autoclosure () -> Logger.Metadata? = nil,
                        file: String = #file, function: String = #function, line: UInt = #line) {
        self.warning(message(), metadata: metadata(), source: nil, file: file, function: function, line: line)
    }
    #endif

    /// Log a message passing with the ``Logger/Level/error`` log level.
    ///
    /// If `.error` is at least as severe as the `Logger`'s ``logLevel``, it will be logged,
    /// otherwise nothing will happen.
    ///
    /// - parameters:
    ///    - message: The message to be logged. `message` can be used with any string interpolation literal.
    ///    - metadata: One-off metadata to attach to this log message.
    ///    - source: The source this log messages originates from. Defaults
    ///              to the module emitting the log message (on Swift 5.3 or
    ///              newer and the folder name containing the log emitting file on Swift 5.2 or
    ///              older).
    ///    - file: The file this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#fileID` (on Swift 5.3 or newer and `#file` on Swift 5.2 or older).
    ///    - function: The function this log message originates from (there's usually no need to pass it explicitly as
    ///                it defaults to `#function`).
    ///    - line: The line this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#line`).
    #if compiler(>=5.3)
    @inlinable
    public func error(taMessage: @autoclosure () -> TAMessage,
                      metadata: @autoclosure () -> Logger.Metadata? = nil,
                      source: @autoclosure () -> String? = nil,
                      file: String = #fileID, function: String = #function, line: UInt = #line) {
        self.log(level: .error, taMessage: taMessage(), metadata: metadata(), source: source(), file: file, function: function, line: line)
    }

    #else
    @inlinable
    public func error(taMessage: @autoclosure () -> TAMessage,
                      metadata: @autoclosure () -> Logger.Metadata? = nil,
                      source: @autoclosure () -> String? = nil,
                      file: String = #file, function: String = #function, line: UInt = #line) {
        self.log(level: .error, message(), metadata: metadata(), source: source(), file: file, function: function, line: line)
    }
    #endif

    /// Log a message passing with the ``Logger/Level/error`` log level.
    ///
    /// If `.error` is at least as severe as the `Logger`'s ``logLevel``, it will be logged,
    /// otherwise nothing will happen.
    ///
    /// - parameters:
    ///    - message: The message to be logged. `message` can be used with any string interpolation literal.
    ///    - metadata: One-off metadata to attach to this log message.
    ///    - file: The file this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#fileID` (on Swift 5.3 or newer and `#file` on Swift 5.2 or older).
    ///    - function: The function this log message originates from (there's usually no need to pass it explicitly as
    ///                it defaults to `#function`).
    ///    - line: The line this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#line`).
    #if compiler(>=5.3)
    @inlinable
    public func error(taMessage: @autoclosure () -> TAMessage,
                      metadata: @autoclosure () -> Logger.Metadata? = nil,
                      file: String = #fileID, function: String = #function, line: UInt = #line) {
        self.error(taMessage: taMessage(), metadata: metadata(), source: nil, file: file, function: function, line: line)
    }

    #else
    @inlinable
    public func error(taMessage: @autoclosure () -> TAMessage,
                      metadata: @autoclosure () -> Logger.Metadata? = nil,
                      file: String = #file, function: String = #function, line: UInt = #line) {
        self.error(message(), metadata: metadata(), source: nil, file: file, function: function, line: line)
    }
    #endif

    /// Log a message passing with the ``Logger/Level/critical`` log level.
    ///
    /// `.critical` messages will always be logged.
    ///
    /// - parameters:
    ///    - message: The message to be logged. `message` can be used with any string interpolation literal.
    ///    - metadata: One-off metadata to attach to this log message.
    ///    - source: The source this log messages originates from. Defaults
    ///              to the module emitting the log message (on Swift 5.3 or
    ///              newer and the folder name containing the log emitting file on Swift 5.2 or
    ///              older).
    ///    - file: The file this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#fileID` (on Swift 5.3 or newer and `#file` on Swift 5.2 or older).
    ///    - function: The function this log message originates from (there's usually no need to pass it explicitly as
    ///                it defaults to `#function`).
    ///    - line: The line this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#line`).
    #if compiler(>=5.3)
    @inlinable
    public func critical(taMessage: @autoclosure () -> TAMessage,
                         metadata: @autoclosure () -> Logger.Metadata? = nil,
                         source: @autoclosure () -> String? = nil,
                         file: String = #fileID, function: String = #function, line: UInt = #line) {
        self.log(level: .critical, taMessage: taMessage(), metadata: metadata(), source: source(), file: file, function: function, line: line)
    }

    #else
    @inlinable
    public func critical(taMessage: @autoclosure () -> TAMessage,
                         metadata: @autoclosure () -> Logger.Metadata? = nil,
                         source: @autoclosure () -> String? = nil,
                         file: String = #file, function: String = #function, line: UInt = #line) {
        self.log(level: .critical, message(), metadata: metadata(), source: source(), file: file, function: function, line: line)
    }
    #endif

    /// Log a message passing with the ``Logger/Level/critical`` log level.
    ///
    /// `.critical` messages will always be logged.
    ///
    /// - parameters:
    ///    - message: The message to be logged. `message` can be used with any string interpolation literal.
    ///    - metadata: One-off metadata to attach to this log message.
    ///    - source: The source this log messages originates from. Defaults
    ///              to the module emitting the log message (on Swift 5.3 or
    ///              newer and the folder name containing the log emitting file on Swift 5.2 or
    ///              older).
    ///    - file: The file this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#fileID` (on Swift 5.3 or newer and `#file` on Swift 5.2 or older).
    ///    - function: The function this log message originates from (there's usually no need to pass it explicitly as
    ///                it defaults to `#function`).
    ///    - line: The line this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#line`).
    #if compiler(>=5.3)
    @inlinable
    public func critical(taMessage: @autoclosure () -> TAMessage,
                         metadata: @autoclosure () -> Logger.Metadata? = nil,
                         file: String = #fileID, function: String = #function, line: UInt = #line) {
        self.critical(taMessage: taMessage(), metadata: metadata(), source: nil, file: file, function: function, line: line)
    }

    #else
    @inlinable
    public func critical(taMessage: @autoclosure () -> TAMessage,
                         metadata: @autoclosure () -> Logger.Metadata? = nil,
                         file: String = #file, function: String = #function, line: UInt = #line) {
        self.critical(message(), metadata: metadata(), source: nil, file: file, function: function, line: line)
    }
    #endif
}

extension Logger {
    @inlinable
    internal static func currentModule(filePath: String = #file) -> String {
        let utf8All = filePath.utf8
        return filePath.utf8.lastIndex(of: UInt8(ascii: "/")).flatMap { lastSlash -> Substring? in
            utf8All[..<lastSlash].lastIndex(of: UInt8(ascii: "/")).map { secondLastSlash -> Substring in
                filePath[utf8All.index(after: secondLastSlash) ..< lastSlash]
            }
        }.map {
            String($0)
        } ?? "n/a"
    }

    #if compiler(>=5.3)
    @inlinable
    internal static func currentModule(fileID: String = #fileID) -> String {
        let utf8All = fileID.utf8
        if let slashIndex = utf8All.firstIndex(of: UInt8(ascii: "/")) {
            return String(fileID[..<slashIndex])
        } else {
            return "n/a"
        }
    }
    #endif
}
