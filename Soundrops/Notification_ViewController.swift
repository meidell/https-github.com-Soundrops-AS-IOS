//
//  Notification_ViewController.swift
//  Soundrops
//
//  Created by Jan Erik Meidell on 28.02.2024.
//  Copyright © 2024 Jan Erik Meidell. All rights reserved.
//

import UIKit
import UserNotifications

class Notification_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - UI Setup
    
    private func setupViews() {
        view.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "Allow Notifications"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        let messageLabel = UILabel()
        messageLabel.text = "Allow this app to send you notifications."
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageLabel)
        
        let allowButton = UIButton(type: .system)
        allowButton.setTitle("Allow", for: .normal)
        allowButton.addTarget(self, action: #selector(allowButtonTapped), for: .touchUpInside)
        allowButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(allowButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            allowButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            allowButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 50)
        ])
    }
    
    // MARK: - Button Actions
    
    @objc private func allowButtonTapped() {
        requestNotificationAuthorization()
    }
    
    // MARK: - Notification Authorization
    
    private func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] (granted, error) in
            if granted {
                // Notification permission granted
                DispatchQueue.main.async {
                    self?.dismiss(animated: true, completion: nil)
                }
                print("Notification granted.")

            } else {
                // Notification permission denied
                print("Notification permission denied.")
            }
        }
    }

}
