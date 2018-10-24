//
//  CustomLogFileManager.swift
//  DevLog
//
//  Created by vdh on 18.06.18.

import Foundation
import CocoaLumberjack

/// Create custom log file names
class CustomLogFileManager: DDLogFileManagerDefault {
    let dateFormat = "dd-MM-yyyy_HH:mm:ss"
    
    override var newLogFileName: String! {
        let fileName = String(format: "%@ %@.log", getAppName(), getTimeStamp())
        //print(fileName)
        return fileName
    }
    
    override func isLogFile(withName _: String!) -> Bool {
        return true
    }
    
    func getTimeStamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let timeStamp = dateFormatter.string(from: Date())
        //print(timeStamp)
        return timeStamp
    }
    
    func getAppName() -> String {
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
        return appName
    }
}
