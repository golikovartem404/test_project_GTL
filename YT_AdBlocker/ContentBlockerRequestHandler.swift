//
//  ContentBlockerRequestHandler.swift
//  YT_AdBlocker
//
//  Created by User on 02.01.2023.
//

import UIKit
import MobileCoreServices

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        let sharedContainerURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.Artem-Golikov.test-project-GTL.batch")
        let sourceURL = sharedContainerURL?.appendingPathComponent("allowList.json")
        let ruleAttachment = NSItemProvider(contentsOf: sourceURL)
//        let attachment = NSItemProvider(contentsOf: Bundle.main.url(forResource: "blockerList", withExtension: "json"))!
        
        let item = NSExtensionItem()
        item.attachments = ([ruleAttachment] as! [NSItemProvider])
        
        context.completeRequest(returningItems: [item], completionHandler: nil)
    }
    
}
