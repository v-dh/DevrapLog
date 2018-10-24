//
//  CustomLogFormatter.swift
//  DevLog
//
//  Created by vdh on 18.06.18.

import Foundation
import CocoaLumberjack

/// Create custom log formats
class CustomLogFormatter: NSObject, DDLogFormatter {
    func format(message logMessage: DDLogMessage) -> String? {
        return "\(logMessage.message)"
    }
}
