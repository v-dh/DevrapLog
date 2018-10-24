//
//  CustomLogger.swift
//  DevLog
//
//  Created by vdh on 18.06.18.

import Foundation
import CocoaLumberjack

/// Custom logger using CocoaLumberjack
class CustomLogger: DevLogging {
    func DevLog(message: @autoclosure () -> String, file: String = #file, function: StaticString = #function, line: UInt = #line,
                level: LogLevel) {

        let formatter = LogManager.dateFormatter
        let date = formatter.string(from: Date())
        
        var _file = String()
        if file.components(separatedBy: "/").last != nil {
            _file = file.components(separatedBy: "/").last!
        }
        
        switch level {
            case .verbose:
                DDLogVerbose("\(date) [\(_file):\(function):\(line)] \(level.toString()): \(message())")
            case .debug:
                DDLogDebug("\(date) [\(_file):\(function):\(line)] \(level.toString()): \(message())")
            case .info:
                DDLogInfo("\(date) [\(_file):\(function):\(line)] \(level.toString()): \(message())")
            case .warning:
                DDLogWarn("\(date) [\(_file):\(function):\(line)] \(level.toString()): \(message())")
            case .error:
                DDLogError("\(date) [\(_file):\(function):\(line)] \(level.toString()): \(message())")
        }
    }
}
