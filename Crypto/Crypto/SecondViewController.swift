//
//  SecondViewController.swift
//  Crypto
//
//  Created by Vlados iOS on 2/5/19.
//  Copyright © 2019 Vladislav Shilov. All rights reserved.
//

import Cocoa

class SecondViewController: NSViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet private weak var openFileButton: NSButton!
    @IBOutlet private weak var saveFileButton: NSButton!
    @IBOutlet private weak var cancelButton: NSButton!
    @IBOutlet private weak var pathControl: NSPathControl!
    @IBOutlet private weak var filePathTextField: NSTextField!
    
    @IBOutlet private weak var passwordCollectionView: NSCollectionView!
    @IBOutlet private weak var passwordTextField: NSTextField!
    @IBOutlet private weak var setPasswordButton: NSButton!
    @IBOutlet private weak var generatePasswordButton: NSButton!
    
    // MARK: - Properties
    private var fileManager: IFileManagerService = FileManagerService()
    
    private let randomWords = ["random", "password", "oleg", "word"]
    
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
        
        fileManager.delegate = self
        pathControl.url = nil
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
        
        if dialog.runModal() == .OK, let fileUrl = dialog.url, let directoryUrl = dialog.directoryURL {
            fileManager.setURLs(fileURL: fileUrl, directoryURL: directoryUrl)
        } else {
            return
        }
    }
    
    @IBAction func saveFileButtonDidPress(_ sender: Any) {
        fileManager.save(string: "test save string")
    }
    
    @IBAction func cancelButtonDidPress(_ sender: Any) {
        fileManager.directoryURL = nil
        pathControl.url = nil
        filePathTextField.stringValue = ""
        filePathTextField.resignFirstResponder()
    }
    
    @IBAction func setPasswordButtonDidPress(_ sender: Any) {
        password = passwordTextField.stringValue
        
        updateCollectionView()
    }
    
    @IBAction func generatePasswordButtonDidPress(_ sender: Any) {
        let random = UInt32(randomWords.count - 1)
        let index = Int(arc4random_uniform(random))
        password = randomWords[index]
        
        updateCollectionView()
    }
}

// MARK: - Private methods

extension SecondViewController {
    // MARK: Generate alphabet
    private func generateMatrix(with password: String) {
        matrix.removeAll()
        password.uppercased().forEach { ch in
            if !matrix.contains(ch), ch != "Q" {
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
    }
    
    private func updateCollectionView() {
        generateMatrix(with: password)
        configureCollectionView()
        passwordCollectionView.reloadData()
        passwordCollectionView.layout()
    }
}

// MARK: - NSTextFieldDelegate

extension SecondViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        if obj.object as? NSTextField == filePathTextField {
            fileManager.setFileName(filePathTextField.stringValue)
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
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "MartixItem"), for: indexPath)
        guard let collectionViewItem = item as? MartixItem else {return item}
        
        collectionViewItem.titleLabel.stringValue = matrix[indexPath.item].uppercased()
        return item
    }
}

// MARK: - FileManagerServiceDelegate {

extension SecondViewController: FileManagerServiceDelegate {
    func fileURLDidChange(_ fileURL: URL) {
        pathControl.url = fileURL
    }
    
    func fileNameDidChange(_ fileName: String) {
        filePathTextField.stringValue = fileName
    }
}
