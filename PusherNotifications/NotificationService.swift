//import UserNotifications
//import Alamofire
//import KeychainSwift
//import AVFoundation
//
//class NotificationService: UNNotificationServiceExtension {
//
//    var contentHandler: ((UNNotificationContent) -> Void)?
//    var bestAttemptContent: UNMutableNotificationContent?
//    var camPID: String = "0"
//    var channel: String = ""
//    
//    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
//        self.contentHandler = contentHandler
//        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
//        
//        if let bestAttemptContent = bestAttemptContent {
//            // Adding a unique custom sound
//            bestAttemptContent.sound = UNNotificationSound(named: UNNotificationSoundName("dunk.aiff"))
//            
//            // Modify the title with company name if available
//            if let company = request.content.userInfo["company"] as? String {
//                bestAttemptContent.title = "\(company)"
//            }
//            
//            // Attach an image if available
//            if let attachmentUrlString = request.content.userInfo["attachment-url"] as? String,
//               let attachmentUrl = URL(string: attachmentUrlString) {
//                downloadAndAttachMedia(from: attachmentUrl, for: bestAttemptContent, contentHandler: contentHandler)
//            } else {
//                // No media to attach, just deliver the notification
//                contentHandler(bestAttemptContent)
//            }
//        }
//        
//        if KeychainSwift().get("channel") != nil {
//            channel = KeychainSwift().get("channel")! as String
//            
//            if channel != "" {
//                
//                if let notificationData = request.content.userInfo["data"] as? [String: Any] {
//                    if let campaignID = notificationData["campaign-id"] as? Int {
//                        // Check if the campaign ID is 0 and prevent the notification from displaying
//                        if campaignID == 0 {
//                            guard let url2 = URL(string: "https://appservice1.share50.no/silentpush/update") else { return }
//                            var request2 = URLRequest(url: url2)
//                            request2.httpMethod = "POST"
//                            request2.setValue("androidios", forHTTPHeaderField: "authorization")
//                            request2.setValue("greatballsoffire", forHTTPHeaderField: "password")
//                            request2.setValue("application/json", forHTTPHeaderField: "Content-Type")
//                            request2.setValue(channel, forHTTPHeaderField: "channel")
//                            let task = URLSession.shared.dataTask(with: request2) { data, response, error in
//                                if let error = error {
//                                    return
//                                }
//                            }
//                            task.resume()
//                            return
//                        } else {
//                            camPID = String(campaignID)
//                            guard let url = URL(string: "https://statservice1.share50.no/stats/track") else { return }
//                            var request1 = URLRequest(url: url)
//                            request1.httpMethod = "PATCH"
//                            request1.setValue("androidios", forHTTPHeaderField: "authorization")
//                            request1.setValue("greatballsoffire", forHTTPHeaderField: "password")
//                            request1.setValue(channel, forHTTPHeaderField: "channel")
//                            request1.setValue(channel, forHTTPHeaderField: "channelid")
//                            request1.setValue("application/json", forHTTPHeaderField: "Content-Type")
//                            
//                            let json: [String: Any] = [
//                                "lat": "0",
//                                "lng": "0",
//                                "channelid": channel,
//                                "cmpid": camPID,
//                                "action": "10"
//                            ]
//                            
//                            do {
//                                let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
//                                request1.httpBody = jsonData
//                            } catch {
//                                return
//                            }
//                            
//                            let task = URLSession.shared.dataTask(with: request1) { data, response, error in
//                                if error != nil {
//                                    return
//                                }
//                            }
//                            task.resume()
//                        }
//                    }
//                }
//            }
//        }
//            
//    }
//
//    override func serviceExtensionTimeWillExpire() {
//        // Called just before the extension will be terminated
//        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
//            contentHandler(bestAttemptContent)
//        }
//    }
//    
//    // Helper function to download and attach media
//    private func downloadAndAttachMedia(from url: URL, for content: UNMutableNotificationContent, contentHandler: @escaping (UNNotificationContent) -> Void) {
//        AF.download(url).responseData { response in
//            guard let data = response.value else {
//                // Failed to download, deliver the original notification
//                print("Failed to download image: \(response.error?.localizedDescription ?? "Unknown error")")
//                contentHandler(content)
//                return
//            }
//            
//            let imageFileIdentifier = UUID().uuidString + ".png"
//            
//            // Use the extension to save the image to disk and create the attachment
//            if let attachment = UNNotificationAttachment.saveImageToDisk(imageFileIdentifier: imageFileIdentifier, data: data as NSData, options: nil) {
//                content.attachments = [attachment]
//            } else {
//                print("Failed to create attachment")
//            }
//            
//            // Deliver the notification with or without the attachment
//            contentHandler(content)
//        }
//    }
//    
//    // Helper function to create an attachment from downloaded data
//    private func createAttachment(from data: Data, withExtension fileExtension: String) -> UNNotificationAttachment? {
//        let tempDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
//        let tempFile = tempDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension(fileExtension)
//        
//        do {
//            try data.write(to: tempFile)
//            let attachment = try UNNotificationAttachment(identifier: UUID().uuidString, url: tempFile, options: nil)
//            return attachment
//        } catch {
//            print("Error creating attachment: \(error)")
//            return nil
//        }
//    }
//}
//
//extension UNNotificationAttachment {
//
//    /// Saves image data to disk and returns a UNNotificationAttachment if successful.
//    static func saveImageToDisk(imageFileIdentifier: String, data: NSData, options: [NSObject: AnyObject]?) -> UNNotificationAttachment? {
//        let fileManager = FileManager.default
//        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
//        let tmpSubFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)
//
//        do {
//            try fileManager.createDirectory(at: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)
//            let fileURL = tmpSubFolderURL.appendingPathComponent(imageFileIdentifier)
//            try data.write(to: fileURL, options: [])
//            let attachment = try UNNotificationAttachment(identifier: imageFileIdentifier, url: fileURL, options: options)
//            return attachment
//        } catch {
//            print("Error saving image to disk: \(error)")
//            return nil
//        }
//    }
//}
//
//
//
//
//
//
//
//




import UserNotifications
import MobileCoreServices
import UIKit
import Alamofire
import KeychainSwift
import AVKit


class NotificationService: UNNotificationServiceExtension {
    
    var camPID: String = "0"
    var channel: String = ""
    var player: AVPlayer?
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        guard let bestAttemptContent = bestAttemptContent else {
            contentHandler(request.content)
            return
        }
        
        func failBack() {
            contentHandler(request.content)
        }
        
        if KeychainSwift().get("channel") != nil {
            channel = KeychainSwift().get("channel")! as String
            
            if channel != "" {
                
                if let notificationData = request.content.userInfo["data"] as? [String: Any] {
                    if let campaignID = notificationData["campaign-id"] as? Int {
                        // Check if the campaign ID is 9999 and prevent the notification from displaying
                        if campaignID == 0 {
                            guard let url2 = URL(string: "https://appservice1.share50.no/silentpush/update") else { return }
                            var request2 = URLRequest(url: url2)
                            request2.httpMethod = "POST"
                            request2.setValue("androidios", forHTTPHeaderField: "authorization")
                            request2.setValue("greatballsoffire", forHTTPHeaderField: "password")
                            request2.setValue("application/json", forHTTPHeaderField: "Content-Type")
                            request2.setValue(channel, forHTTPHeaderField: "channel")
                            let task = URLSession.shared.dataTask(with: request2) { data, response, error in
                                if let error = error {
                                    return
                                }
                            }
                            task.resume()
                            return
                        } else {
                            camPID = String(campaignID)
                            guard let url = URL(string: "https://statservice1.share50.no/stats/track") else { return }
                            var request1 = URLRequest(url: url)
                            request1.httpMethod = "PATCH"
                            request1.setValue("androidios", forHTTPHeaderField: "authorization")
                            request1.setValue("greatballsoffire", forHTTPHeaderField: "password")
                            request1.setValue(channel, forHTTPHeaderField: "channel")
                            request1.setValue(channel, forHTTPHeaderField: "channelid")
                            request1.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                            let json: [String: Any] = [
                                "lat": "0",
                                "lng": "0",
                                "channelid": channel,
                                "cmpid": camPID,
                                "action": "10"
                            ]
                    
                            do {
                                let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                                request1.httpBody = jsonData
                            } catch {
                                return
                            }
                    
                            let task = URLSession.shared.dataTask(with: request1) { data, response, error in
                                if error != nil {
                                    return
                                }
                            }
                            task.resume()
                            
                            // Set notification title from company data
                            if let company = notificationData["company"] as? String {
                                bestAttemptContent.title = company
                            }
                            
                            if let attachmentURLString = notificationData["attachment-url"] as? String,
                               let attachmentURL = URL(string: attachmentURLString),
                               let imageData = NSData(contentsOf: attachmentURL) {
                                
                                if let attachment = UNNotificationAttachment.saveImageToDisk(imageFileIdentifier: "image.jpeg", data: imageData, options: nil) {
                                    bestAttemptContent.attachments = [attachment]
                                } else {
                                    return failBack()
                                }
                            } else {
                                return failBack()
                            }
                            
                        }
                    }
                }
            }
        }
        
        contentHandler(bestAttemptContent.copy() as! UNNotificationContent)
    }
    
//    override func serviceExtensionTimeWillExpire() {
//        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
//            contentHandler(bestAttemptContent)
//        }
//    }
}

extension UNNotificationAttachment {
    
    /// Saves image data to disk and returns a UNNotificationAttachment if successful.
    static func saveImageToDisk(imageFileIdentifier: String, data: NSData, options: [NSObject: AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        let tmpSubFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)
        
        do {
            try fileManager.createDirectory(at: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)
            let fileURL = tmpSubFolderURL.appendingPathComponent(imageFileIdentifier)
            try data.write(to: fileURL, options: [])
            let attachment = try UNNotificationAttachment(identifier: imageFileIdentifier, url: fileURL, options: options)
            return attachment
        } catch {
            print("Error saving image to disk: \(error)")
            return nil
        }
    }
}
