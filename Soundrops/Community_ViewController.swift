//
//  CommunityViewController.swift
//  Soundrops
//
//  Created by Jan Erik Meidell on 23.05.18.
//  Copyright © 2018 Jan Erik Meidell. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftUI
import Charts
import Foundation


class Community_ViewController: UIViewController {
        
    @IBOutlet weak var lblOrganisation: UILabel!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var lblMembers: UILabel!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var btnTell: UIButton!
    @IBOutlet weak var lblFunds: UILabel!
    @IBOutlet weak var textCommunity: UILabel!
    @IBOutlet var fldAntall: UIView!
    @IBOutlet var btnSmile: UIView!
    
    @IBAction func btnHome(_ sender: Any) {
        self.performSegue(withIdentifier: "community_to_profile1", sender: self)
    }
    
    @IBAction func btnTell(_ sender: Any) {
        
        let orgIdString = String(decoding: String(myorg.orgid).data(using: String.Encoding.utf8)!, as: UTF8.self)
        let usernameString = String(decoding: myuser.username.data(using: .utf8)!, as: UTF8.self)
        let data = "orgid#" + orgIdString + "__user#" + usernameString
        
        let encodedData = (data.data(using: .utf8)?.base64EncodedString())!
        let urlString = "https://share50.no/org/" + encodedData
        // Swift code
       // let urlString = "https://vg.no"
        guard let url = URL(string: urlString) else { return }

        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.postToTwitter, .saveToCameraRoll] // Optional: exclude unwanted activities
        present(activityViewController, animated: true, completion: nil)
    }
    
    func base64Encode(_ data: String) -> String? {
        guard let encodedData = data.data(using: .utf8)?.base64EncodedString() else {
            return nil
        }
        return encodedData
    }
  
    
    override func viewDidAppear(_ animated: Bool) {self.navigationController?.isNavigationBarHidden = true}
    
    override func viewDidLoad() {
        super.viewDidLoad()
    

        AF.request(myorg.orglogo).responseImage { response in
            switch response.result {
               case .success(let image):
                    self.logo.image = image
               
                case .failure(let error):
                    print("Error loading image: \(error)")
            }
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        let result = formatter.string(from: NSNumber(value: myorg.orgrevenue))
        self.lblFunds.text = "NOK "+result!
        self.lblMembers.text = String(myorg.orgfollowers)
        self.lblOrganisation.text = myorg.orgname
        self.textCommunity.text = "Tusen takk for din støtte. Vennlig hilsen " + myorg.orgname + "."
        
        
        let myColour = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        btnTell.layer.cornerRadius = 6
        btnTell.layer.borderWidth = 1
        btnTell.layer.borderColor = myColour.cgColor
        let attributedString4 = NSAttributedString(string: NSLocalizedString("Verv en venn", comment: ""),attributes:[NSAttributedString.Key.underlineStyle:0])
        btnTell.setAttributedTitle(attributedString4, for: .normal)
        
        let frame = lblMembers.frame //Frame of label
        let topLayer = CALayer()
        topLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: 1)
        topLayer.backgroundColor = UIColor.gray.cgColor
        lblMembers.layer.addSublayer(topLayer)
     
        let frame1 = lblAmount.frame //Frame of label
        let topLayer1 = CALayer()
        topLayer1.frame = CGRect(x: 0, y: 0, width: frame1.width, height: 1)
        topLayer1.backgroundColor = UIColor.gray.cgColor
        lblAmount.layer.addSublayer(topLayer1)
        
        logo.layer.cornerRadius = 5.0
        logo.clipsToBounds = true
        
        btnHome.backgroundColor = .clear
        btnHome.layer.cornerRadius = btnHome.frame.width / 2
        btnHome.layer.borderWidth = 1
        btnHome.layer.borderColor = myColour.cgColor
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
        let image = UIImage(systemName: "arrowshape.turn.up.backward.2.fill", withConfiguration: largeConfig)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        btnHome.setImage(image, for: .normal)
        btnHome.imageView?.contentMode = .scaleAspectFit
        
        
        setupUI()

    }
    
    private func setupUI() {
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

          let contentView = HistogramView().edgesIgnoringSafeArea(.all)
          let hostingController = UIHostingController(rootView: contentView)
            addChild(hostingController)
        hostingController.view.frame = CGRect(x: screenWidth*0.08, y: screenHeight*0.49, width: screenWidth*0.5, height: screenHeight*0.30)
            view.addSubview(hostingController.view)
            hostingController.didMove(toParent: self)
      }
}

struct Revenues: Identifiable {
    let id = UUID()
    let period: String
    let amount: Double
}

let revenueDatas: [Revenues] = [
    Revenues(period: "200", amount: 31),
    Revenues(period: "600", amount: 94),
    Revenues(period: "1800", amount: 281),
]

struct HistogramView: View {
    
    @State private var chartOpacity: Double = 0.0

    var body: some View {
        VStack {
            Chart(revenueDatas) {
                BarMark(
                    x: .value("Period", $0.period),
                    y: .value("Amount", $0.amount)
                )
                .foregroundStyle(Color(red: 0.12, green: 0.62, blue: 0.4))
                
            }
            .opacity(chartOpacity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 2.5)) {
                        chartOpacity = 1.0
                    }
            }
            .chartXAxis {
                AxisMarks(position: .bottom, values: .automatic) { value in
                    AxisGridLine().foregroundStyle(.clear)
                    AxisValueLabel()
                }
            }
            .chartYAxis {
                AxisMarks(position: .trailing, values: .automatic) { value in
                    AxisGridLine(centered: true, stroke: StrokeStyle(lineWidth: 1))
                    AxisValueLabel() {
                        if let intValue = value.as(Int.self) {
                            Text("\(intValue)k")
                            .font(.system(size: 10))
                        }
                    }
                }
            }
        }
       
    }
}

