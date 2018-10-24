//
//  LogFileListPresenter.swift
//  DevLog
//
//  Created by vdh on 18.06.18.

import CocoaLumberjack
import Zip
//import Reachability

protocol LogFileListUserInterface: class {
    func updateView()
}

class LogFileListPresenter {
    
    weak var view: LogFileListUserInterface?
    private let zipFileName = "log_files"
    
    
    /// Start new session
    
    func startNewSessionLogs() {
        LogInfo("newSession")
    }
    
    /// Add logs for demo use
    func initNewLogFile() {
        //let device = Device.self
        let uuid = UUID().uuidString
        LogInfo("Start logging : 📱 \(getOSInfo()) - \(UIDevice.current.systemVersion) - \(uuid)")
    }
    
    func deleteLogFile() {
        LogInfo("Delete all log files")
        let filelogger = LogUtils.getFileLogger()
        for filename in (filelogger?.logFileManager.sortedLogFilePaths)! {
            do{
                print(filename)
                try FileManager.default.removeItem(atPath: filename)
            }
            catch{
                print(error)
            }
            
        }
        
        //filelogger?.rollLogFile(withCompletion: {})
    }
    
    /// Finish current log file
    func rollLogFile() {
        LogInfo("Roll log files")
        LogUtils.getFileLogger()?.rollLogFile(withCompletion: {
            DispatchQueue.main.async {
                self.view?.updateView()
            }
        })
    }
    
    func getLogArchivedCount() -> Int {
        let allFiles = LogUtils.getFileLogger()?.logFileManager?.sortedLogFileNames
        let number = (allFiles?.count)!
        
        if ( number > 1) {
            return number-1
        }
        else {
            return 0
        }
    }
    
    
    /// Get log file name for row (and  cut off project name for display reasons)
    func getLogFileName(for indexPath: IndexPath) -> String? {
        
        let allFiles = LogUtils.getFileLogger()?.logFileManager?.sortedLogFileNames
        if (indexPath.section == 0) {
            if let fileName = allFiles?[0].components(separatedBy: " ").last {
                return fileName
            }
        }
        else {
            let row = indexPath.row+1
            if let fileName = allFiles?[row].components(separatedBy: " ").last {
                return fileName
            }
            else
            {return ""}
        }
        return ""
    }
    
    /// Zip all log files and return data and path
    func getZipFileDataAndPath() -> (Data, URL?) {
        let logFilePathStringArray = LogUtils.getFileLogger()?.logFileManager.sortedLogFilePaths
        var logFilePathUrlArray = [URL]()
        var zipFileData = Data()
        var zipFilePath: URL?
        if logFilePathStringArray != nil {
            for logFilePathString in logFilePathStringArray! {
                logFilePathUrlArray.append(URL(fileURLWithPath: logFilePathString, isDirectory: false))
            }
        }
        do {
            zipFilePath = try Zip.quickZipFiles(logFilePathUrlArray, fileName: zipFileName)
            if !zipFilePath!.absoluteString.isEmpty
            {
                zipFileData = try Data(contentsOf:zipFilePath!)
            }
        }
        catch {
            print(error)
        }
        return (zipFileData, zipFilePath)
    }
    
    /// Remove zip file
    func removeZipFile(zipFilePath: URL?) {
        if zipFilePath != nil {
            do {
                try FileManager.default.removeItem(atPath: zipFilePath!.path)
            }
            catch {
                print(error)
            }
        }
    }
}


//
func getAppInfo()->String {
    let dictionary = Bundle.main.infoDictionary!
    let version = dictionary["CFBundleShortVersionString"] as! String
    let build = dictionary["CFBundleVersion"] as! String
    return version + "(" + build + ")"
}

func getAppName()->String {
    let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
    return appName
}

func getOSInfo()->String {
    let os = ProcessInfo().operatingSystemVersion
    return String(os.majorVersion) + "." + String(os.minorVersion) + "." + String(os.patchVersion)
}
