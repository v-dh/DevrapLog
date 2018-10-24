//
//  LogFileTableViewController.swift
//  DevLog
//
//  Created by vdh on 18.06.18.

import UIKit
import MessageUI
//import Reachability

class LogFileTableViewController: UITableViewController, LogFileListUserInterface, MFMailComposeViewControllerDelegate {
    
    @IBAction func xibHideLogs(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion:nil)
        
    }
    
    var presenter = LogFileListPresenter()
    private var zipFileData = Data()
    private var zipFilePath: URL?
    private let logFileCellName = "LogFileCell"
    private let textViewSegueName = "TextViewSegue"
    private let numberOfTableViewSections = 1
    
    override func viewDidLoad() {
        presenter.view = self
        presenter.startNewSessionLogs()
        updateView()
    }
    
    /// Add logs for demo use
    @IBAction func addTestLogs(sender: AnyObject) {
        presenter.deleteLogFile()
        presenter.initNewLogFile()
        updateView()
    }
    
    /// Finish current log file
    @IBAction func rollLogFile(sender: AnyObject) {
        presenter.rollLogFile()
        presenter.initNewLogFile()
    }
    
    /// Mail log files as zipped attachment
    @IBAction func mailAllZippedLogs(sender: AnyObject) {
        /// Check to see if the device can send emails
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            LogInfo("Create an 📩 with 🗜")
            zipFileData = presenter.getZipFileDataAndPath().0
            zipFilePath = presenter.getZipFileDataAndPath().1
            
            /// Set the subject and message of the email
            mailComposer.setToRecipients(["vincent.dhalluin@gmail.com"])
            mailComposer.setSubject("Djingo logs")
            mailComposer.setMessageBody("comments if needed 😏", isHTML: false)
            mailComposer.addAttachmentData(zipFileData, mimeType: "application/gzip", fileName: "log_files.zip")

            /// Present mail composer
            present(mailComposer, animated: true, completion: nil)
        }
    }
    
    /// Remove zip file and dismiss mailComposeController
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            LogInfo("Cancel send ✔")
        case .failed:
            LogError("email send error \(error.debugDescription)")
        case .sent:
            LogInfo("Email send ✔")
        case .saved:
            LogInfo("Email saved ✔")

        }
        LogInfo("removeZipFile")
        presenter.removeZipFile(zipFilePath: zipFilePath)
        controller.dismiss(animated: true, completion: nil)
    }

    /// Create table view sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    /// Create a table view row for every log file
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        }
        else {
            let numberOfArchive = presenter.getLogArchivedCount()
            return numberOfArchive
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Current log file"
        }
        else {
            return "Archives ♻"
        }
    }

    /// Assign the log file name to the text label
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: logFileCellName, for: indexPath)
        cell.textLabel?.text = presenter.getLogFileName(for: indexPath)
        return cell
    }
    
    /// Display text view for selected log file
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: textViewSegueName, sender: self)
    }
    
    /// Assign selected log file index to destination view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let logFileTextVC: LogFileTextViewController = segue.destination as! LogFileTextViewController
        if ((tableView.indexPathForSelectedRow?.row) != nil) {
            let section = (tableView.indexPathForSelectedRow?.section)!
            if (section == 0) {
                logFileTextVC.logFileIndex = 0
            }
            else {
                logFileTextVC.logFileIndex = (tableView.indexPathForSelectedRow?.row)!+1
            }
            
        }
    }
    
    // MARK: LogFileListView

    func updateView() {
        tableView.reloadData()
    }
}
