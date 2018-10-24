//
//  DevLogging.swift
//  DevLog
//
//  Created by vdh on 18.06.18.

import Foundation
//import Reachability

/// Log level definition
public enum LogLevel: Int {
    case error, warning, info, debug, verbose
    
    func toString() -> String {
        switch self {
            case .error:
                return "❌ Error"
            case .warning:
                return "🔔 Warning"
            case .info:
                return "💡 Info"
            case .debug:
                return "🛠 Debug"
            case .verbose:
                return "💬 Verbose"
        }
    }
}

/// DevLogging interface declaration
protocol DevLogging {
    func DevLog(message: @autoclosure () -> String, file: String, function: StaticString, line: UInt, level: LogLevel)
}

/// DevLogging interface extension (necessary for using default values in function declarations)
extension DevLogging {
    func log(message: @autoclosure () -> String, file: String = #file, function: StaticString = #function, line: UInt = #line,
             level: LogLevel)
    {
        DevLog(message: message, file: file, function: function, line: line, level: level)
    }
}

/// LogManager
public class LogManager {
    static var logger: DevLogging?
    static let dateFormatter: DateFormatter = createDateFormatter()
    static var logLevel: LogLevel = LogLevel.error

    private class func createDateFormatter() -> DateFormatter {
        let dateFormat = "dd-MM-yyyy-MM-dd HH:mm:ss"
        let localeIdentifier = "FR_fr"
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: localeIdentifier)
        formatter.dateFormat = dateFormat
        return formatter
    }
}

/// Definition of public function DevLog
public func DevLog(message: @autoclosure () -> String, file: String = #file, function: StaticString = #function,
                   line: UInt = #line, level: LogLevel) {
    var _file = String()
    
    if file.components(separatedBy: "/").last != nil {
        _file = file.components(separatedBy: "/").last!
    }
    var finalMsg = ""
    
    switch Reachability()?.connection {
    case .none:
        finalMsg = "📵 "+message()
    case .some(.wifi):
        finalMsg = "[wifi] "+message()
    case  .some(.cellular):
        finalMsg = "[cellular] "+message()
    case .some(.none):
        finalMsg = "📵 "+message()
    }
    
    
    if let logger = LogManager.logger {
        logger.log(message: finalMsg, file: _file, function: function, line: line, level: level)
    }
    else if level.rawValue > LogManager.logLevel.rawValue
    {
        let date = LogManager.dateFormatter.string(from: Date())
        print("\(date) [\(_file):\(function):\(line)] \(level.toString()): \(finalMsg)")
    }
}

public func LogDebug(_ message:String, file: String = #file, function: StaticString = #function, line: UInt = #line) {
    DevLog(message: message, file:file, function:function, level: .debug)
}

public func LogWarn(_ message:String, file: String = #file, function: StaticString = #function, line: UInt = #line) {
    DevLog(message: message, file:file, function:function, level: .warning)
}

public func LogError(_ message:String, file: String = #file, function: StaticString = #function, line: UInt = #line) {
    DevLog(message: message, file:file, function:function, level: .error)
}

public func LogInfo(_ message:String, file: String = #file, function: StaticString = #function, line: UInt = #line) {
    DevLog(message: message, file:file, function:function, level: .info)
}

public func LogVerbose(_ message:String, file: String = #file, function: StaticString = #function, line: UInt = #line) {
    DevLog(message: message, file:file, function:function, level: .verbose)
}
