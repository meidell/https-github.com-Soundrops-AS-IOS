//
//  Graph_ViewController.swift
//  Soundrops
//
//  Created by Jan Erik Meidell on 03.02.2024.
//  Copyright © 2024 Jan Erik Meidell. All rights reserved.
//

import UIKit
import SwiftUI
import Charts


// 1. Data model
struct Revenue: Identifiable {
    let id = UUID()
    let period: String
    let amount: Double
}

// 2. Data as an array of Revenue objects
let revenueData: [Revenue] = [
    Revenue(period: "2022 Q1", amount: 125525.25),
    Revenue(period: "2022 Q2", amount: 154389.50),
    Revenue(period: "2022 Q3", amount: 131987.90),
    Revenue(period: "2022 Q4", amount: 178965.80)
]


class Graph_ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    private func setupUI() {
        
          let contentView = ContentView().edgesIgnoringSafeArea(.all)
          let hostingController = UIHostingController(rootView: contentView)
            addChild(hostingController)
            view.addSubview(hostingController.view)
          hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                   hostingController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 600),
                   hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                   hostingController.view.widthAnchor.constraint(equalToConstant: 250),
                   hostingController.view.heightAnchor.constraint(equalToConstant: 200),
               ])
          hostingController.didMove(toParent: self)
      }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Chart(revenueData) {
                BarMark(
                    x: .value("Period", $0.period),
                    y: .value("Amount", $0.amount)
                )
            }
        }
        .padding()
    }
}
