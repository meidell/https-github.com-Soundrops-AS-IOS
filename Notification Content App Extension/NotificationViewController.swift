//
//  NotificationViewController.swift
//  Notification Content App Extension
//
//  Created by Jan Erik Meidell on 02.07.19.
//  Copyright © 2019 Jan Erik Meidell. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import Alamofire
import AlamofireImage
import AVKit
import AVFoundation


class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    
    
    @IBOutlet weak var img_sound: UIImageView!
    @IBOutlet weak var btn_volume: UIButton!
    @IBOutlet weak var view_player: UIView!
    @IBOutlet weak var lbl_company_name: UILabel!
    @IBOutlet weak var img_label: UIImageView!
    @IBOutlet weak var img_logo: UIImageView!
    @IBOutlet weak var lbl_headline: UILabel!
    @IBOutlet weak var lbl_message: UILabel!
    
    var player : AVPlayer?
    var playerItem:AVPlayerItem?
    var playButton:UIButton?
    var my_image:UIImage?
    var campaign_id:Int = 0
    let window: UIWindow? = nil
    var channel:String = ""
    
    
    // @IBAction func btn_openapp(_ sender: Any) {
    
    //  let defaults = UserDefaults(suiteName: "group.Lexigo.Soundrops")
    //    defaults?.set(String(campaign_id), forKey: "alarmTime")
    //    defaults?.synchronize()
    
    //    let mystring = "mydrop://" + String(campaign_id)
    //    self.extensionContext?.open(URL(string: mystring)!, completionHandler: nil)
    
    //  }
    
    @IBAction func btn_volume(_ sender: Any) {
        
        if player?.volume == 10 {
            player?.volume = 0
            img_sound.image = UIImage(named: "sound_off")
        } else {
            player?.volume = 10
            img_sound.image = UIImage(named: "sound_on")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // tell the app that we have finished processing the user’s action / response
        completionHandler()
    }
    
    func didReceive(_ notification: UNNotification) {
        
        if let PusherNotificationData = notification.request.content.userInfo["data"] as? NSDictionary {
            channel = String(PusherNotificationData["channel"] as! String)
            let exclusive = Bool(PusherNotificationData["exclusive"] as! Bool)
            campaign_id = Int(PusherNotificationData["campaign-id"] as! Int)
            if exclusive  { self.title = "EXCLUSIVE" }
            let video = Bool(PusherNotificationData["video"] as! Bool)
            
            if video {
                
                lbl_headline.frame.origin.y = view.frame.height*0.6
                lbl_message.frame.origin.y = view.frame.height*0.75
                
                let attachmentURL1  = String(PusherNotificationData["logo-url"] as! String)
                Alamofire.request(attachmentURL1).responseImage { response in
                    if let image = response.result.value {
                        self.img_logo.image = image
                        self.my_image? = image
                        
                        let imageView1 = UIImageView(image: image)
                        imageView1.image = image
                        
                        imageView1.frame = CGRect(x: 15, y: 205, width: 60, height: 43)
                        imageView1.backgroundColor = UIColor.blue
                        let myColour2 = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
                        imageView1.layer.borderWidth = 1
                        imageView1.layer.borderColor =  myColour2.cgColor
                        imageView1.tag = 102
                        self.view.addSubview(imageView1)
                    }
                }
                
                let videourl = String(PusherNotificationData["videourl"] as! String)
                
                self.img_label.image = nil
                self.img_logo.image = nil
                self.img_label.isHidden = true
                self.img_logo.isHidden = true
                
                let videoURL = URL(string: videourl)
                player = AVPlayer(url: videoURL!)
                let playerLayer = AVPlayerLayer(player: player)
                playerLayer.frame = self.view_player.bounds
                self.view.layer.addSublayer(playerLayer)
                
                playButton = UIButton(type: UIButton.ButtonType.system) as UIButton
                let xPostion:CGFloat = 0
                let yPostion:CGFloat = 40
                let buttonWidth:CGFloat = 320
                let buttonHeight:CGFloat = 150
                playButton!.frame = CGRect(x:xPostion, y:yPostion, width:buttonWidth, height:buttonHeight)
                playButton!.backgroundColor = UIColor.clear
                playButton!.tintColor = UIColor.black
                playButton!.addTarget(self, action: #selector(NotificationViewController.playButtonTapped(_:)), for: .touchUpInside)
                playButton!.tag = 101
                
                self.view.addSubview(playButton!)
                
                player?.play()
                player?.volume = 0
                
                NotificationCenter.default.addObserver(self, selector: #selector(NotificationViewController.finishVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
                
            } else {
                
                lbl_headline.frame.origin.y = view.frame.height*0.65
                lbl_message.frame.origin.y = view.frame.height*0.8
                btn_volume.isHidden = true
                img_sound.isHidden = true
                self.img_logo.isHidden = false
                self.img_label.isHidden = false
                
                
                let attachmentURL  = String(PusherNotificationData["attachment-url"] as! String)
                self.img_label.image = UIImage(contentsOfFile: attachmentURL)
                Alamofire.request(attachmentURL).responseImage { response in
                    if let image = response.result.value {
                        self.img_label.image = image
                    }
                }
                let attachmentURL1  = String(PusherNotificationData["logo-url"] as! String)
                Alamofire.request(attachmentURL1).responseImage { response in
                    if let image = response.result.value {
                        self.img_logo.image = image
                    }
                }
            }
            
            let companyName = String(PusherNotificationData["company"] as! String)
            self.lbl_company_name?.text = companyName
                
        }
        

       // self.lbl_company_name?.text = companyName//notification.request.content.title
      //  self.lbl_message?.text = notification.request.content.body
      //  self.lbl_headline?.text = notification.request.content.subtitle
        if self.lbl_company_name?.text == "Share//50 Community" {
            self.img_logo.isHidden = true
        } else {
        }
        
        let myColour2 = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
        
        self.img_logo.layer.borderWidth = 1
        self.img_logo.layer.borderColor =  myColour2.cgColor
        
        let frame1 = lbl_message.frame
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: 0, width: frame1.width, height: 1)
        bottomLayer.backgroundColor = myColour2.cgColor
        lbl_message.layer.addSublayer(bottomLayer)

        let url  = String("https://appservice.soundrops.com/stats/set")
        let json = ["cmp_id": campaign_id,"cmp_action": 18, "user_id": self.channel] as [String : Any]
        Alamofire.request(url, method: .post, parameters: json, encoding: JSONEncoding.default)
            .response { response in
        }
        
    }
    
    @objc func finishVideo()
    {
        let seconds : Int64 = Int64(0)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        player!.seek(to: targetTime)
    }
    
    @objc func playButtonTapped(_ sender:UIButton)
    {
        if player?.rate == 0
        {
            player!.play()
        } else {
            player!.pause()
            //           playButton!.setTitle("Play", for: UIControl.State.normal)
        }
    }
}

