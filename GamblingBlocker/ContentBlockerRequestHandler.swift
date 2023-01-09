//
//  ContentBlockerRequestHandler.swift
//  GamblingBlocker
//
//  Created by User on 31.12.2022.
//

import UIKit
import MobileCoreServices

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        let defaults = UserDefaults(suiteName: "group.Artem-Golikov.test-project-GTL.batch")
        let whiteList = defaults?.object(forKey: "whiteListSites") as? [[String: [String: Any]]]
        if let whiteList = whiteList, whiteList.isEmpty {
            let imageValue = defaults?.bool(forKey: "isImageBlocked")
            let mediaValue = defaults?.bool(forKey: "isMediaBlocked")
            switch (imageValue, mediaValue) {
            case (true, true):
                setupContext(with: context, andFileName: "blockerListAll")
            case (true, false):
                setupContext(with: context, andFileName: "blockerListImages")
            case (false, true):
                setupContext(with: context, andFileName: "blockerListMedia")
            case (false, false):
                setupContext(with: context, andFileName: "blockerListUsual")
            case (_, _):
                return
            }
        } else {
            let sharedContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.Artem-Golikov.test-project-GTL.batch")
            let sourceURL = sharedContainerURL?.appendingPathComponent("allowList.json")
            let ruleAttachment = NSItemProvider(contentsOf: sourceURL)
            let item = NSExtensionItem()
            item.attachments = ([ruleAttachment] as! [NSItemProvider])
            context.completeRequest(returningItems: [item], completionHandler: nil)
        }
    }

    private func setupContext(with context: NSExtensionContext, andFileName fileName: String) {
        let attachment = NSItemProvider(contentsOf: Bundle.main.url(forResource: fileName, withExtension: "json"))!
        let item = NSExtensionItem()
        item.attachments = [attachment]
        context.completeRequest(returningItems: [item], completionHandler: nil)
    }
}
