# SwiftLogOSLogHandler

**SwiftLogOSLogHandler** is a logging backend for Apple’s [swift-log](https://github.com/apple/swift-log). It integrates with Apple’s [OSLog](https://developer.apple.com/documentation/os/logging) Unified Logging system and provides advanced string interpolation for flexible, compile-time-controlled logging.

---

## Features

- **Apple Unified Logging Integration**: Leverage OSLog for optimized, structured, and categorized logging.
- **Advanced String Interpolation**: Customize log messages with options like privacy, formatting, alignment, and more.

---

## Installation

### Swift Package Manager

To include **SwiftLogOSLogHandler** in your project, add it to your `Package.swift` file:

```swift
let package = Package(
    name: "YourProject",
    platforms: [
        .iOS(.v14),
        .macOS(.v10_13)
    ],
    dependencies: [
        .package(
            url: "git@github.com:TechArtists/ios-swift-log-os-log-handler.git",
            from: "1.0.0"
        )
    ],
    targets: [
        .target(
            name: "YourTarget",
            dependencies: [
                .product(name: "SwiftLogOSLogHandler", package: "SwiftLogOSLogHandler")
            ]
        )
    ]
)
```
Alternatively, to add the package using Xcode:

    1. Navigate to File > Add Packages.
    2. Enter the repository URL: `git@github.com:TechArtists/ios-swift-log-os-log-handler.git`.
    3. Add the package to your target.
## Usage

To effectively utilize logging in your application, initialize and manage your loggers using the `init(label: String, factory: (String) -> any LogHandler)` method of the `Logger`. This method allows for versatile logging configurations, making it easy to combine `SwiftLogOSLogHandler` with other logging handlers, such as file-based handlers, using the `MultiplexLogHandler`.

```swift
import Logging
import Foundation
import SwiftLogFileLogHandler
import SwiftLogOSLogHandler

enum Loggers {
    static let main = Logging.Logger(label: "main") { label in
        MultiplexLogHandler([
            SwiftLogOSLogHandler(label: label, shouldLogCallsiteMetadata: true),
            SwiftLogFileLogHandler(label: label)
        ])
    }
    
    static let onboarding = Logging.Logger(label: "onboarding") { label in
        MultiplexLogHandler([
            SwiftLogOSLogHandler(label: label),
            SwiftLogFileLogHandler(label: label)
        ])
    }
}

Loggers.main.info("Welcome Main Logger")
Loggers.onboarding.info("Welcome Onboarding logger")

// Output
// Main: Welcome Main Logger
// Onboarding: Welcome Onboarding logger

```

## Differences Between `SwiftLogOSLogHandler` and `OS_log`

While `SwiftLogOSLogHandler` provides a convenient bridge to integrate Apple's OSLog system with the Swift logging API, there are some important distinctions to consider when choosing between using this library and using `OS_log` directly:

### Performance

- **OSlog Optimizations**: The native `OSlog` API is optimized for performance, offering efficient logging capabilities that are tailored specifically for Apple's operating systems. This includes direct support for various log levels, privacy controls, and more, with minimal overhead.
- **SwiftLogOSLogHandler Efficiency**: Using `SwiftLogOSLogHandler` introduces some overhead compared to directly using `OSlog`, due to the additional layer that bridges Swift's logging system with `OSlog`. However, this trade-off is generally acceptable for many applications that benefit from the streamlined logging API provided by `swift-log`.

### Call Site Accuracy

- **OS_log Call Site**: The native `OSlog` accurately captures the call site information (file, function, line) and associates this metadata directly with each log entry.
- **SwiftLogOSLogHandler Call Site**: Due to the way Swift’s logging system interacts with `OS_log`, the call site information will not reflect the actual source of the log message but rather the location within the handler itself. To compensate for this, `SwiftLogOSLogHandler` offers a `shouldLogCallsiteMetadata` parameter. When enabled, this option appends call site metadata directly into your log messages in the format: `[File: \(file), Function: \(function), Line: \(line)]`:

```swift
let main = SwiftLogOSLogHandler(label: "example", shouldLogCallsiteMetadata: true)

// Example Log Message
main.info("Important action performed")

// Output
// Important action performed [File: Example.swift, Function: performAction, Line: 42]
```

### Advanced String Interpolation with `taMessage`

The `taMessage` parameter allows for enhanced string interpolation in log messages, including:
- **Privacy Options**: Use `.public` or `.private` to control the visibility of log message content.
- **Formatting**: Apply formatting options such as `.fixed` for numeric precision.
- **Alignment**: Define alignment and column width for text.

**Example Usage**:

```swift
let testString = "Performance Test"
let cpuUsage = 89.57

Loggers.main.info(taMessage: "\(testString, privacy: .public)")
Loggers.main.error(taMessage: "High CPU usage: \(cpuUsage, format: .fixed(precision: 2), align: .left(columns: 10))%")
Loggers.main.critical(taMessage: "System health critical. \(UUID(), privacy: .private) CPU: \(cpuUsage, privacy: .public)")
Loggers.main.notice(taMessage: "Running maintenance. Task ID: \(UUID(), privacy: .public)")
```

**Example Output**:

```
Performance Test [File: SystemMonitor.swift, Function: checkPerformance, Line: 120]
High CPU usage: <redacted>%
System health critical. <redacted> CPU: 89.57
Running maintenance. Task ID: 5E6A10C8-45F0-4923-8C28-3A6C8D17F7AA
```

### Logging with Bootstrapping

To ensure all logs are effectively captured and routed through the desired logging backend, you need to bootstrap the logging system. Bootstrapping associates a specific handler, such as `SwiftLogOSLogHandler`, to all `Logger` instances created thereafter.

Here’s how to configure OSLog as the universal backend by bootstrapping the logging system:

```swift
import Logging
import SwiftLogOSLogHandler

// Bootstrap the logging system with OSLog as the handler.
LoggingSystem.bootstrap { label in
    SwiftLogOSLogHandler(label: label)
}

// Create a Logger instance after bootstrapping.
let loggerMain = Logger(label: "Main")

// Log messages using the logger instance.
// These messages will now be routed and handled by the bootstrapped SwiftLogOSLogHandler.
loggerMain.info("Application started successfully.")
loggerMain.warning("Low disk space detected.")
```

**OSLog Output**:
```
Main: info: Application started successfully.
Main: warning: Low disk space detected.
```

### Important Considerations

- **Bootstrap Before Using Loggers**: Ensure that you bootstrap the logging system *before* creating any `Logger` instances. Loggers created prior to bootstrapping will not be associated with the specified backend and may not output logs as expected.
  
- **Universal Handling**: Once you bootstrap with `SwiftLogOSLogHandler`, all subsequent `Logger` instances in your application will use OSLog, ensuring consistent and centralized logging behavior.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.
