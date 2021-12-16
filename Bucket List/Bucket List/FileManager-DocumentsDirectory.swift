//
//  FileManagerExtension.swift
//  Bucket List
//
//  Created by Kuba Milcarz on 14/12/2021.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = self.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func write(content: String, to fileName: String, with encoding: String.Encoding = .utf8) -> String {
        let url = self.getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            try content.write(to: url, atomically: true, encoding: encoding)
            
            return "Success"
        } catch {
            return error.localizedDescription
        }
    }
    
    func read(from fileName: String) -> String {
        let url = self.getDocumentsDirectory().appendingPathComponent(fileName)
        
        do {
            let content = try String(contentsOf: url)
            
            return content
        } catch {
            return error.localizedDescription
        }
    }
}
