//
//  ShareViewController.swift
//  ShareTest
//
//  Created by Neethu Krishnan on 08/10/20.
//  Copyright © 2020 DDUKK. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        guard contentText.count > 0 else {
            return false
        }
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        
        let configItems = self.configurationItems()[0] as! SLComposeSheetConfigurationItem
        // extracting the path to the URL that is being shared
        let attachments = (self.extensionContext?.inputItems.first as? NSExtensionItem)?.attachments ?? []
        let contentType = kUTTypeData as String
        for provider in attachments {
          // Check if the content type is the same as we expected
          if provider.hasItemConformingToTypeIdentifier(contentType) {
            provider.loadItem(forTypeIdentifier: contentType,
                              options: nil) { [unowned self] (data, error) in
            // Handle the error here if you want
            guard error == nil else { return }
                 
            if let url = data as? URL,
               let imageData = try? Data(contentsOf: url) {
                let dict: [String : Any] = ["imgData" :  imageData, "name" : self.contentText!]
                let savedata =  UserDefaults(suiteName: "group.com.ddukk.ShareExtensionDemo")
                savedata?.set(dict, forKey: "img")

            } else {
              // Handle this situation as you prefer
              fatalError("Impossible to save image")
            }
          }}
        }
        
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        let item  = SLComposeSheetConfigurationItem()
        item?.title = "To:"
        item?.value = "John"
        return [item!]
    }

}
