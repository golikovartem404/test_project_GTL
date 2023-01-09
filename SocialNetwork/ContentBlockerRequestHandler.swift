//
//  ContentBlockerRequestHandler.swift
//  SocialNetwork
//
//  Created by User on 31.12.2022.
//

import UIKit
import MobileCoreServices

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        let defaults = UserDefaults(suiteName: "group.Artem-Golikov.test-project-GTL.batch")
            let adBlockValue = defaults?.bool(forKey: "isADBlocked")
            switch adBlockValue {
            case true:
                setupContext(with: context, andFileName: "blockerList2")
            case false:
                setupContext(with: context, andFileName: "blockerList3")
            case .none:
                return
            case .some(_):
                return
            }
//            let attachment = NSItemProvider(contentsOf: Bundle.main.url(forResource: "blockerList2", withExtension: "json"))!
//
//            let item = NSExtensionItem()
//            item.attachments = [attachment]
//
//            context.completeRequest(returningItems: [item], completionHandler: nil)
        }


    private func setupContext(with context: NSExtensionContext, andFileName fileName: String) {
        let attachment = NSItemProvider(contentsOf: Bundle.main.url(forResource: fileName, withExtension: "json"))!
        let item = NSExtensionItem()
        item.attachments = [attachment]
        context.completeRequest(returningItems: [item], completionHandler: nil)
    }

    
}
