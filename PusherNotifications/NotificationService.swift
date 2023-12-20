//
//  NotificationService.swift
//  PusherNotifications
//
//  Created by Jan Erik Meidell on 30.05.18.
//  Copyright © 2018 Jan Erik Meidell. All rights reserved.
//

import UserNotifications
import MobileCoreServices
import UIKit
import Alamofire



class NotificationService: UNNotificationServiceExtension {
    
    var camPID:String = "0"
    var title: String = ""
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    var channel:String = ""
    
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        
      
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        func failBack() {
            contentHandler(request.content)
        }
     
        if let PusherNotificationData = request.content.userInfo["data"] as? NSDictionary {
            if let campaignID = PusherNotificationData["campaign-id"] as? Int {
                camPID=String(campaignID)
            }
            
            if let company = PusherNotificationData["company"] as? String {
                self.bestAttemptContent?.title =  company
            }
            
        //    title = (self.bestAttemptContent?.body)!
         //   self.bestAttemptContent?.body = title
         //   title = (self.bestAttemptContent?.subtitle)!
         //   self.bestAttemptContent?.subtitle = title
            
            if let attachmentURL = PusherNotificationData["attachment-url"] as? String {
                guard let imageData = NSData.init(contentsOf: URL.init(string: attachmentURL)!) else { return failBack() }
                guard let attachment = UNNotificationAttachment.saveImageToDisk(imageFileIdentifier: "image.jpeg", data: imageData, options: nil) else { return failBack() }
                bestAttemptContent?.attachments = [attachment]
            }
            else {
                return failBack()
            }
        }
        contentHandler(bestAttemptContent?.copy() as! UNNotificationContent)
    }
    
    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}

extension UNNotificationAttachment {
    
    /// Save the image to disk. We could not get the notification to work without this.
    static func saveImageToDisk(imageFileIdentifier: String, data: NSData, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        let tmpSubFolderURL = URL.init(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)
        do {
            try fileManager.createDirectory(at: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)
            let fileURL = tmpSubFolderURL.appendingPathComponent(imageFileIdentifier)
            
            try data.write(to: fileURL, options: [])
            let imageAttachment = try UNNotificationAttachment(identifier: imageFileIdentifier, url: fileURL, options: options)
            return imageAttachment
        //} catch let error {
        } catch _ {
        }
        return nil
    }
}
