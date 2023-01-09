//
//  UIViewController + Ext.swift
//  test_project_GTL
//
//  Created by User on 07.01.2023.
//

import UIKit
import SafariServices

extension UIViewController {

    func writeJSON(
        withObject object: Any,
        andFileName fileName: String,
        groupIDentifier groupIdentifier: String,
        blockerIDentifier blockerIdentifier: String
    ) {
        let jsonData = try! JSONSerialization.data(
            withJSONObject: object,
            options: .prettyPrinted
        )
        if let json = String(data: jsonData, encoding: String.Encoding.utf8) {
            let file = "\(fileName).json"
            if let dir = FileManager.default.containerURL(
                forSecurityApplicationGroupIdentifier: groupIdentifier
            ) {
                let path = dir.appendingPathComponent(file)
                do {
                    print(json)
                    try json.write(
                        to: path,
                        atomically: false,
                        encoding: String.Encoding.utf8
                    )
                    SFContentBlockerManager.reloadContentBlocker(
                        withIdentifier: blockerIdentifier
                    ) { error in
                        guard error == nil else {
                            print(error ?? "Error")
                            return
                        }
                        print("Reloaded successfully")
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
