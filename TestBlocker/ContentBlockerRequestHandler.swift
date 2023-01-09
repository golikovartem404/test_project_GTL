//
//  ContentBlockerRequestHandler.swift
//  TestBlocker
//
//  Created by User on 02.01.2023.
//

import UIKit
import MobileCoreServices

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        let defaults = UserDefaults(suiteName: "group.Artem-Golikov.test-project-GTL.batch")
        let blackList = defaults?.object(forKey: "blackListSites") as? [[String: [String: Any]]]
        if let blacklist = blackList, blacklist.isEmpty {
            let attachment = NSItemProvider(contentsOf: Bundle.main.url(forResource: "blockerListForTest", withExtension: "json"))!
            let item = NSExtensionItem()
            item.attachments = [attachment]
            context.completeRequest(returningItems: [item], completionHandler: nil)
        } else {
            let sharedContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.Artem-Golikov.test-project-GTL.batch")
            let sourceURL = sharedContainerURL?.appendingPathComponent("whiteList.json")
            let ruleAttachment = NSItemProvider(contentsOf: sourceURL)
            let item = NSExtensionItem()
            item.attachments = ([ruleAttachment] as! [NSItemProvider])
            context.completeRequest(returningItems: [item], completionHandler: nil)
        }
    }

}
