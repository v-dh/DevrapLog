//
//  LogUtils.swift
//  DevLog
//
//  Created by vdh on 18.06.18.

import Foundation
import CocoaLumberjack

public class LogUtils {
    
    public init() {}
    
    /// Configure CocoaLumberjack
    private let rollingFrequency: TimeInterval = 60 * 60 * 24 // every 24 hours
    private let maximumNumberOfLogFiles: UInt = 7 // for one week
    private let maximumFileSize: UInt64 = 1024 * 1024 // 1 mega byte
    private let doNotReuseLogFiles = false // reuse log files

    /// Setup CocoaLumberjack
    public func setupLogger(logLevel: DDLogLevel, addASLLogger: Bool, addTTYLogger: Bool) {
        if let logsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path {
            let logFileManager = CustomLogFileManager(logsDirectory: logsDirectory)
            let fileLogger: DDFileLogger = DDFileLogger(logFileManager: logFileManager)
            fileLogger.rollingFrequency = rollingFrequency
            fileLogger.logFileManager.maximumNumberOfLogFiles = maximumNumberOfLogFiles
            fileLogger.maximumFileSize = maximumFileSize
            fileLogger.doNotReuseLogFiles = doNotReuseLogFiles
            fileLogger.logFormatter = CustomLogFormatter()
            DDLog.add(fileLogger, with: logLevel)
        }
        if addASLLogger {
            if let ASLLogger = DDASLLogger.sharedInstance
            {
                ASLLogger.logFormatter = CustomLogFormatter()
                DDLog.add(ASLLogger, with: logLevel)
            }
        }
        if addTTYLogger {
            if let TTYLogger = DDTTYLogger.sharedInstance
            {
                TTYLogger.logFormatter = CustomLogFormatter()
                DDLog.add(TTYLogger, with: logLevel)
            }
        }
    }
    
    /// Get file logger
    static func getFileLogger() -> DDFileLogger? {
        var fileLogger = DDFileLogger()
        for logger in DDLog.allLoggers {
            if logger is DDFileLogger {
                fileLogger = logger as? DDFileLogger
            }
        }
        return fileLogger
    }
}
