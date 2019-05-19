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
    @IBOutlet private weak var cancelButton: NSButton!
    @IBOutlet private weak var pathControl: NSPathControl!
    @IBOutlet private weak var filePathTextField: NSTextField!
    
    @IBOutlet private weak var passwordCollectionView: NSCollectionView!
    @IBOutlet private weak var passwordTextField: NSTextField!
    @IBOutlet private weak var setPasswordButton: NSButton!
    @IBOutlet private weak var generatePasswordButton: NSButton!
    
    
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
    
    private var password = ""
    private lazy var matrix: [Character] = {
        let startChar = Unicode.Scalar("A").value
        let endChar = Unicode.Scalar("Z").value

        var newAlpahbet = [Character]()
        for alphabet in startChar...endChar {
            if let scalar = Unicode.Scalar(alphabet), Character(scalar) != "Q" {
                newAlpahbet.append(Character(scalar))
            }
        }
        print(newAlpahbet)

        return newAlpahbet
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
//        directoryURL = paths.first!
        directoryURL = nil
        
        pathControl.url = directoryURL
        filePathTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        configureCollectionView()
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
    
    @IBAction func setPasswordButtonDidPress(_ sender: Any) {
        password = passwordTextField.stringValue
        generateMatrix(with: password)
        
        configureCollectionView()
        passwordCollectionView.reloadData()
    }
    
    @IBAction func generatePasswordButtonDidPress(_ sender: Any) {
        
    }
}

// MARK: - Private methods

extension SecondViewController {
    private func configureFileURL() {
        guard let directoryURL = directoryURL else { return }
        
        if fileName != ".txt" {
            fileURL = directoryURL.appendingPathComponent(fileName)
            pathControl.url = fileURL
            filePathTextField.stringValue = String(fileName.dropLast(fileExtension.count))
        }
        else {
            pathControl.url = directoryURL
        }
    }
    
    private func saveData(_ data: Data, at url: URL) throws {
        try data.write(to: url)
    }
    
    // MARK: Generate alphabet
    private func generateMatrix(with password: String) {
        matrix.removeAll()
        password.uppercased().forEach { ch in
            if !matrix.contains(ch) {
                matrix.append(ch)
            }
        }
        
        let startChar = Unicode.Scalar("A").value
        let endChar = Unicode.Scalar("Z").value
        
        for alphabet in startChar...endChar {
            if let scalar = Unicode.Scalar(alphabet), !password.uppercased().contains(Character(scalar)), Character(scalar) != "Q" {
                self.matrix.append(Character(scalar))
            }
        }
        print(matrix)
    }
    
    // MARK: - collectionview
    private func configureCollectionView() {
        let flowLayout = NSCollectionViewFlowLayout()
        
        let divideFactor = matrix.count % 5 == 0 ? matrix.count / 5 : (matrix.count / 5 + 1)
        let width = passwordCollectionView.frame.width / 5
        let height = passwordCollectionView.frame.width / CGFloat(divideFactor)
        
        flowLayout.itemSize = NSSize(width: width, height: height)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        passwordCollectionView.collectionViewLayout = flowLayout

        //view.wantsLayer = true
    
        //passwordCollectionView.layer?.backgroundColor = NSColor.black.cgColor
    }
}

// MARK: - NSTextFieldDelegate

extension SecondViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        if obj.object as? NSTextField == filePathTextField {
            fileName = filePathTextField.stringValue + fileExtension
            configureFileURL()
        }
        if obj.object as? NSTextField == passwordTextField {
            
        }
    }
}

// MARK: - NSCollectionViewDelegate

extension SecondViewController: NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return matrix.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "BiogrammItem"), for: indexPath)
        guard let collectionViewItem = item as? BiogrammItem else {return item}
        
        collectionViewItem.titleLabel.stringValue = matrix[indexPath.item].uppercased()
        return item
    }
}

