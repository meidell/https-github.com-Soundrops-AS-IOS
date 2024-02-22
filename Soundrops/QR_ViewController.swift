import UIKit
import CoreData
import AVFoundation

class QR_ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var maskLayer: CAShapeLayer!
    var backButton: UIButton!
    var admin: Bool = false
    
    @IBOutlet weak var btnHome: UIButton!
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "romseo.png")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let qrCodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "10 stempler gir en gratis."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stampStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
//    let stempleButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Nytt stempel", for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
    let scanQRCodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Scan QR Code", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var stampFields: [StampView] = []
    var currentStampCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        admin=QRadmin
        
        let myColour = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)

        btnHome.frame.size.width = btnHome.frame.height
        btnHome.backgroundColor = .white
        btnHome.layer.cornerRadius = btnHome.frame.width / 2
        btnHome.layer.borderWidth = 1
        btnHome.layer.borderColor = myColour.cgColor
        let image = UIImage(systemName: "house.fill", withConfiguration: largeConfig)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        btnHome.setImage(image, for: .normal)
        btnHome.imageView?.contentMode = .scaleAspectFit
        
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(instructionLabel)
        view.addSubview(stampStackView)
     //   view.addSubview(stempleButton)
        if admin {
            view.addSubview(qrCodeImageView)
            
            let text = "hello.there"
            let qrCode = generateQRCodeImage(from: text)
            qrCodeImageView.image = qrCode
            
        } else {
            view.addSubview(scanQRCodeButton)
            captureSession = AVCaptureSession()

            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
            let videoInput: AVCaptureDeviceInput

            do {
                videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                return
            }

            if (captureSession.canAddInput(videoInput)) {
                captureSession.addInput(videoInput)
            } else {
                failed()
                return
            }

            let metadataOutput = AVCaptureMetadataOutput()

            if (captureSession.canAddOutput(metadataOutput)) {
                captureSession.addOutput(metadataOutput)

                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.qr]
            } else {
                failed()
                return
            }

            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.isHidden = true
            view.layer.addSublayer(previewLayer)

            setupMaskLayer()
        }
        
        setupLayout()
        setupStampFields()
        
     //   stempleButton.addTarget(self, action: #selector(addStamp), for: .touchUpInside)
        scanQRCodeButton.addTarget(self, action: #selector(scanQRCode), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !admin {
            updatePreviewLayerFrame()
            updateMaskLayer()
        }
    }

    func setupMaskLayer() {
        maskLayer = CAShapeLayer()
        maskLayer.fillRule = .evenOdd
        view.layer.addSublayer(maskLayer)
        updateMaskLayer()
    }

    func updateMaskLayer() {
//        let path = UIBezierPath(rect: view.bounds)
//
//        let squareWidth = view.bounds.width * 0.8
//        let squareRect = CGRect(
//          x: view.bounds.width * 0.1,
//          y: 400,
//          width: squareWidth,
//          height: squareWidth
//        )
//        let squarePath = UIBezierPath(rect: squareRect)
//        path.append(squarePath.reversing())

     //   maskLayer.path = path.cgPath
   //     maskLayer.fillColor = UIColor.white.withAlphaComponent(1.0).cgColor
    }

    func updatePreviewLayerFrame() {
        let squareWidth = view.bounds.width * 0.8
        let squareRect = CGRect(
            x: view.bounds.width * 0.1,
            y: scanQRCodeButton.frame.maxY + 20,
            width: squareWidth,
            height: squareWidth
        )
        previewLayer.frame = squareRect
    }

    func failed() {
        let alertController = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
        captureSession = nil
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

        dismiss(animated: true)
    }

    func found(code: String) {
        handleQRCodeContent(code)
        addStamp()
        hideCameraPreview()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    func handleQRCodeContent(_ content: String) {
        // Handle the QR code content and navigate within your app
        if let url = URL(string: content) {
            UIApplication.shared.open(url)
        }
    }

    func setupLayout() {
        let padding: CGFloat = view.frame.width * 0.1
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 160), // Adjust as needed
            imageView.heightAnchor.constraint(equalToConstant: 60), // Adjust as needed
            
            instructionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            stampStackView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 20),
            stampStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stampStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
//            stempleButton.topAnchor.constraint(equalTo: stampStackView.bottomAnchor, constant: 20),
//            stempleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        if admin {
            NSLayoutConstraint.activate([
                qrCodeImageView.topAnchor.constraint(equalTo: stampStackView.bottomAnchor, constant: 20),
                qrCodeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                qrCodeImageView.widthAnchor.constraint(equalToConstant: 200),
                qrCodeImageView.heightAnchor.constraint(equalToConstant: 200)
            ])
        } else {
            NSLayoutConstraint.activate([
                scanQRCodeButton.topAnchor.constraint(equalTo: stampStackView.bottomAnchor, constant: 20),
                scanQRCodeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }
    }

    func setupStampFields() {
        let rows = 2
        let columns = 5
        for _ in 0..<rows {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.distribution = .fillEqually
            rowStackView.spacing = 20
            stampStackView.addArrangedSubview(rowStackView)
            
            for _ in 0..<columns {
                let stampField = StampView()
                stampFields.append(stampField)
                rowStackView.addArrangedSubview(stampField)
                
                // Add constraints to stampField to make it a square
                stampField.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    stampField.widthAnchor.constraint(equalTo: stampField.heightAnchor),
                    stampField.heightAnchor.constraint(equalToConstant: 30) // Adjust height to make the circle smaller
                ])
            }
        }
    }

    func generateQRCodeImage(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("Q", forKey: "inputCorrectionLevel")
            
            if let qrCodeImage = filter.outputImage {
                let transformedImage = qrCodeImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
                return UIImage(ciImage: transformedImage)
            }
        }
        
        return nil
    }

    @objc func scanQRCode() {
        showCameraPreview()
        captureSession.startRunning()
    }

    @objc func addStamp() {
        if currentStampCount < 10 {
            stampFields[currentStampCount].markAsStamped()
            currentStampCount += 1
        }
    }
    
    @objc func hideCameraPreview() {
        captureSession.stopRunning()
        previewLayer.isHidden = true
        maskLayer.isHidden = true
    }

    @IBAction func btnHome(_ sender: Any) {
        self.performSegue(withIdentifier: "QR_Profile", sender: self)
    }

    func showCameraPreview() {
        previewLayer.isHidden = false
        maskLayer.isHidden = false
        updatePreviewLayerFrame()
        updateMaskLayer()
    }
}

class StampView: UIView {
    private let innerDot: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let borderWidth: CGFloat = 0.5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .white
        layer.borderWidth = borderWidth
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 15
        clipsToBounds = true
        
        addSubview(innerDot)
        
        NSLayoutConstraint.activate([
            innerDot.centerXAnchor.constraint(equalTo: centerXAnchor),
            innerDot.centerYAnchor.constraint(equalTo: centerYAnchor),
            innerDot.widthAnchor.constraint(equalToConstant: 15),
            innerDot.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        innerDot.layer.cornerRadius = 7.5
    }
    
    func markAsStamped() {
        backgroundColor = .red
        innerDot.backgroundColor = .white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }
}

