//
//  SecondViewController.swift
//  Crypto
//
//  Created by Vlados iOS on 2/5/19.
//  Copyright © 2019 Vladislav Shilov. All rights reserved.
//

import Cocoa

class SecondViewController: NSViewController {
    
    @IBOutlet private weak var openFileButton: NSButton!
    @IBOutlet private weak var saveFileButton: NSButton!
    @IBOutlet weak var cancelButton: NSButton!
    @IBOutlet private weak var pathControl: NSPathControl!
    @IBOutlet private weak var filePathTextField: NSTextField!
    
    private let fileManager = FileManager.default
    private let fileExtension = ".txt"
    private var fileName = ""
    private var directoryURL: URL? {
        didSet {
            saveFileButton.isHidden = directoryURL == nil
            cancelButton.isHidden = directoryURL == nil
        }
    }
    private var fileURL: URL?
    
    private let testDataToSave = "Test data"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        directoryURL = paths.first!
        
        pathControl.url = directoryURL
        filePathTextField.delegate = self
    }
    
    @IBAction func openFileButtonDidPress(_ sender: Any) {
        let dialog = NSOpenPanel();
        
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes        = ["txt"];
        
        if dialog.runModal() == .OK {
            directoryURL = dialog.directoryURL
            fileURL = dialog.url
            
            if let directoryURL = directoryURL, let fileURL = fileURL {
                fileName = String(fileURL.absoluteString.dropFirst(directoryURL.absoluteString.count))
                configureFileURL()
            }
        } else {
            return
        }
    }
    
    @IBAction func saveFileButtonDidPress(_ sender: Any) {
        if let fileURL = fileURL, let data = testDataToSave.data(using: .utf8) {
            do {
                if fileManager.fileExists(atPath: fileURL.path) {
                    try saveData(data, at: fileURL)
                }
                else {
                    fileManager.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
                    try saveData(data, at: fileURL)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func cancelButtonDidPress(_ sender: Any) {
        directoryURL = nil
        pathControl.url = nil
        filePathTextField.stringValue = ""
        filePathTextField.resignFirstResponder()
    }
}

extension SecondViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        fileName = filePathTextField.stringValue
        configureFileURL()
    }
}

extension SecondViewController {
    private func configureFileURL() {
        guard let directoryURL = directoryURL else { return }
        
        if fileName != "" {
            let fileNameWithExtension = fileName + fileExtension
            fileURL = directoryURL.appendingPathComponent(fileNameWithExtension)
            pathControl.url = fileURL
        }
        else {
            pathControl.url = directoryURL
        }
    }
    
    private func saveData(_ data: Data, at url: URL) throws {
        try data.write(to: url)
    }
}
