//
//  FileManagerService.swift
//  Crypto
//
//  Created by Vlados iOS on 5/21/19.
//  Copyright © 2019 Vladislav Shilov. All rights reserved.
//

import Foundation

protocol IFileManagerService {
    var directoryURL: URL? { get set }
    var delegate: FileManagerServiceDelegate? { get set }
    
    func setFileName(_ fileName: String)
    func setURLs(fileURL: URL, directoryURL: URL)
    
    func save(string: String)
}

protocol FileManagerServiceDelegate: class {
    func fileURLDidChange(_ fileURL: URL)
    func fileNameDidChange(_ fileName: String)
}

final class FileManagerService: IFileManagerService {
    
    // MARK: - Properties
    // MARK: IFileManagerService
    var directoryURL: URL?
    var delegate: FileManagerServiceDelegate?
    
    // MARK: Local properties
    private let fileManager = FileManager.default
    private var fileName = "" {
        didSet {
            configureFileURL()
        }
    }
    private let fileExtension = ".txt"
    
    private var fileURL: URL?
    
    private let testDataToSave = "Test data"
    
    // MARK: - Initialization
    init() {
        //        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        //        directoryURL = paths.first!
        directoryURL = nil
    }
    
    // MARK: - Interface
    
    func setFileName(_ fileName: String) {
        self.fileName = fileName + fileExtension
    }
    
    func setURLs(fileURL: URL, directoryURL: URL) {
        self.directoryURL = directoryURL
        self.fileURL = fileURL
        
        fileName = String(fileURL.absoluteString.dropFirst(directoryURL.absoluteString.count))
        configureFileURL()
    }
    
    func save(string: String) {
        if let fileURL = fileURL, let data = string.data(using: .utf8) {
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
}

// MARK: - Support methods

extension FileManagerService {
    private func configureFileURL() {
        guard let directoryURL = directoryURL else { return }
        
        if fileName != ".txt" {
            fileURL = directoryURL.appendingPathComponent(fileName)
            let newFileName = String(fileName.dropLast(fileExtension.count))
            delegate?.fileURLDidChange(fileURL!)
            delegate?.fileNameDidChange(newFileName)
        }
        else {
            delegate?.fileURLDidChange(directoryURL)
        }
    }
    
    private func saveData(_ data: Data, at url: URL) throws {
        try data.write(to: url)
    }
}
