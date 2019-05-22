//
//  SecondViewController.swift
//  Crypto
//
//  Created by Vlados iOS on 2/5/19.
//  Copyright © 2019 Vladislav Shilov. All rights reserved.
//

import Cocoa

class SettingsViewController: NSViewController {
    
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
    
    @IBOutlet private weak var inputMessageTextField: NSTextField!
    @IBOutlet private weak var encryptButton: NSButton!
    
    @IBOutlet private weak var encryptedWordLabel: NSTextField!
    
    @IBOutlet private weak var decryptButton: NSButton!
    @IBOutlet private weak var decryptedWordLabel: NSTextField!
    
    // MARK: - Properties
    private var fileManager: IFileManagerService = FileManagerService()
    private var matrixService: IMatrixService = MatrixService()
    private let encrypter: Encrypter = PlayfairEncypter()
    private let decrypter: Decrypter = PlayfairDecrypter()
    
    private let bigramAdapter = BigramAdapter()
    
    private var encryptedWord = Bigram()
    private var decryptedWord = ""
    
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
    
    @IBAction private func openFileButtonDidPress(_ sender: Any) {
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
    
    @IBAction private func saveFileButtonDidPress(_ sender: Any) {
        fileManager.save(string: "test save string")
    }
    
    @IBAction private func cancelButtonDidPress(_ sender: Any) {
        fileManager.directoryURL = nil
        pathControl.url = nil
        filePathTextField.stringValue = ""
        filePathTextField.resignFirstResponder()
    }
    
    @IBAction private func setPasswordButtonDidPress(_ sender: Any) {
        matrixService.password = passwordTextField.stringValue
        updateCollectionView()
        clearFields()
    }
    
    @IBAction private func generatePasswordButtonDidPress(_ sender: Any) {
        passwordTextField.stringValue = matrixService.generatePassword()
        updateCollectionView()
        clearFields()
    }
    
    @IBAction private func enctyptButtonDidPress(_ sender: Any) {
        encryptedWord = encrypter.encrypt(inputMessageTextField.stringValue, with: matrixService.getMatrix())
        
        encryptedWordLabel.stringValue = bigramAdapter.unwrapp(from: encryptedWord)
    }
    
    @IBAction private func decryptButtonDidPress(_ sender: Any) {
        decryptedWord = decrypter.decrypt(encryptedWord, with: matrixService.getMatrix())
        
        decryptedWordLabel.stringValue = decryptedWord
    }
}

// MARK: - Private methods

extension SettingsViewController {
    // MARK: collectionview
    private func configureCollectionView() {
        let flowLayout = NSCollectionViewFlowLayout()
    
        let matrix = matrixService.getMatrix()
        let divideFactor = matrix.count % 5 == 0 ? matrix.count / 5 : (matrix.count / 5 + 1)
        let width = passwordCollectionView.frame.width / 5
        let height = passwordCollectionView.frame.width / CGFloat(divideFactor)
        
        flowLayout.itemSize = NSSize(width: width, height: height)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        passwordCollectionView.collectionViewLayout = flowLayout
    }
    
    private func updateCollectionView() {
        matrixService.generateMatrix()
        configureCollectionView()
        passwordCollectionView.reloadData()
        passwordCollectionView.layout()
    }
    
    // MARK: - Logic
    private func clearFields() {
        encryptedWord = Bigram()
        decryptedWord = ""
        
        inputMessageTextField.stringValue = ""
        decryptedWordLabel.stringValue = ""
    }
}

// MARK: - NSTextFieldDelegate

extension SettingsViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        if obj.object as? NSTextField == filePathTextField {
            fileManager.setFileName(filePathTextField.stringValue)
        }
        if obj.object as? NSTextField == passwordTextField {
            
        }
    }
}

// MARK: - NSCollectionViewDelegate

extension SettingsViewController: NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return matrixService.getMatrix().count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "MartixItem"), for: indexPath)
        guard let collectionViewItem = item as? MartixItem else {return item}
        
        collectionViewItem.titleLabel.stringValue = matrixService.getMatrix()[indexPath.item].uppercased()
        return item
    }
}

// MARK: - FileManagerServiceDelegate {

extension SettingsViewController: FileManagerServiceDelegate {
    func fileURLDidChange(_ fileURL: URL) {
        pathControl.url = fileURL
    }
    
    func fileNameDidChange(_ fileName: String) {
        filePathTextField.stringValue = fileName
    }
}
