import UIKit
import UserNotifications
import CoreLocation

class Startbefore2_ViewController: UIViewController, CLLocationManagerDelegate {
    
    let subviews = [UIView(), UIView(), UIView(), UIView()]
    var currentSubviewIndex = 0
    var Granted: Bool = false
    var Counter: Int = 0
    var window: UIWindow?
    let progressStackView = UIStackView()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        checkLocationAuthorizationStatus()
        setupSubviews()
        setupSwipeGestures()
        setupProgressBar()
        showSubview(at: 0)
    }
    
    func setupSubviews() {
        for (index, subview) in subviews.enumerated() {
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
            
            let icon = UIImageView()
            icon.contentMode = .scaleAspectFit
            icon.translatesAutoresizingMaskIntoConstraints = false
            subview.addSubview(icon)
            
            let smallTextLabel = UILabel()
            smallTextLabel.font = UIFont.systemFont(ofSize: 19)
            smallTextLabel.textColor = .black
            smallTextLabel.numberOfLines = 6
            smallTextLabel.textAlignment = .center
            smallTextLabel.translatesAutoresizingMaskIntoConstraints = false
            subview.addSubview(smallTextLabel)
            
            let logo = UIImageView(image: UIImage(named: "share50nyicon"))
            logo.contentMode = .scaleAspectFit
            logo.translatesAutoresizingMaskIntoConstraints = false
            subview.addSubview(logo)
            
            let videreLabel = UILabel()
            videreLabel.text = "➔"
            videreLabel.font = UIFont.systemFont(ofSize: 25)
            videreLabel.textColor = .gray
            videreLabel.translatesAutoresizingMaskIntoConstraints = false
            subview.addSubview(videreLabel)
            
            // Add tap gesture recognizer to videreLabel
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLabelTap))
           videreLabel.isUserInteractionEnabled = true
           videreLabel.addGestureRecognizer(tapGesture)
            
            NSLayoutConstraint.activate([
                subview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                subview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                subview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                subview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                
                icon.centerXAnchor.constraint(equalTo: subview.centerXAnchor),
                icon.topAnchor.constraint(equalTo: subview.topAnchor, constant: view.bounds.height * 0.1),
                icon.widthAnchor.constraint(equalTo: subview.widthAnchor, multiplier: 0.35),
                icon.heightAnchor.constraint(equalTo: icon.widthAnchor),
                
                smallTextLabel.centerXAnchor.constraint(equalTo: subview.centerXAnchor),
                smallTextLabel.topAnchor.constraint(equalTo: subview.topAnchor, constant: view.bounds.height * 0.28),
                smallTextLabel.widthAnchor.constraint(equalTo: subview.widthAnchor, multiplier: 0.8),
                
                logo.centerXAnchor.constraint(equalTo: subview.centerXAnchor),
                logo.topAnchor.constraint(equalTo: subview.topAnchor, constant: view.bounds.height * 0.50),
                logo.widthAnchor.constraint(equalTo: subview.widthAnchor, multiplier: 0.4),
                logo.heightAnchor.constraint(equalTo: logo.widthAnchor, multiplier: 0.2),
                
                videreLabel.centerXAnchor.constraint(equalTo: subview.centerXAnchor),
                videreLabel.topAnchor.constraint(equalTo: subview.topAnchor, constant: view.bounds.height * 0.75)
            ])
            
            if index == 0 {
                icon.image = UIImage(named: "Circle")
                smallTextLabel.text = "Velkommen til Share50\n\n Hvor annonseinntektene splittes med organisasjonen du velger."
            }
            if index == 1 {
                icon.image = UIImage(named: "Halfcircle")
                smallTextLabel.text = "Selvfølgelig 50/50."
            }
            if index == 2 {
                icon.image = UIImage(named: "Handshake")
                smallTextLabel.text = "Husk!\nVarslinger må være tillatt for at støttefunksjoner i appen skal fungere."
            }
            
            subview.isHidden = true
        }
    }

    func setupSwipeGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }
    
    @objc func handleLabelTap() {
        // Trigger the left swipe action when videreLabel is tapped
        Counter += 1
        if currentSubviewIndex < subviews.count - 1 {
            showSubview(at: currentSubviewIndex + 1)
        } else if currentSubviewIndex == 2 {
            self.performSegue(withIdentifier: "Startbefore2_Camilla", sender: self)
        }
        updateProgressBar()
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            Counter += 1
            if currentSubviewIndex < subviews.count - 1 {
                showSubview(at: currentSubviewIndex + 1)
            } else if currentSubviewIndex == 2 {
                self.performSegue(withIdentifier: "Startbefore2_Camilla", sender: self)
            }
        } else if gesture.direction == .right {
            Counter -= 1
            if currentSubviewIndex > 0 {
                showSubview(at: currentSubviewIndex - 1)
            }
        }
        updateProgressBar()
    }
    
    func showSubview(at index: Int) {
        if index == 3 {
            requestNotificationAuthorization()
        }
        if index < subviews.count {
            subviews[currentSubviewIndex].isHidden = true
            subviews[index].isHidden = false
            currentSubviewIndex = index
        }
    }
    
    func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                self.Granted = granted
                self.requestLocationAuthorization()
            }
        }
    }
    
    func requestLocationAuthorization() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func checkLocationAuthorizationStatus() {
        let status = CLLocationManager.authorizationStatus()
        if status != .notDetermined {
            // Localization authorization has been answered
            self.performSegue(withIdentifier: "Startbefore2_Camilla", sender: self)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways || status == .denied || status == .restricted {
            self.performSegue(withIdentifier: "Startbefore2_Camilla", sender: self)
        }
    }

    func setupProgressBar() {
        progressStackView.axis = .horizontal
        progressStackView.distribution = .equalSpacing
        progressStackView.alignment = .center
        progressStackView.spacing = 10
        progressStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressStackView)
        
        for _ in 0..<subviews.count {
            let circle = UIView()
            circle.translatesAutoresizingMaskIntoConstraints = false
            circle.backgroundColor = .lightGray
            circle.layer.cornerRadius = 10
            circle.widthAnchor.constraint(equalToConstant: 20).isActive = true
            circle.heightAnchor.constraint(equalToConstant: 20).isActive = true
            progressStackView.addArrangedSubview(circle)
        }
        
        NSLayoutConstraint.activate([
            progressStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        updateProgressBar()
    }
    
    func updateProgressBar() {
        for (index, view) in progressStackView.arrangedSubviews.enumerated() {
            if index == currentSubviewIndex {
                view.backgroundColor = .red
            } else {
                view.backgroundColor = .lightGray
            }
        }
    }
}

