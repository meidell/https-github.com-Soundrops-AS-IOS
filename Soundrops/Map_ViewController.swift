import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import AlamofireImage

class Map_ViewController: UIViewController, GMSMapViewDelegate, UICollectionViewDelegate {
  
    var myDict: Dictionary = [String: String]()
    var Outlet: Dictionary = [String: String]()
    var addview = UIView(frame: CGRect.init(x: 0, y: UIScreen.main.bounds.height*0.18, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.11))
    var zoom: Float = 11
    var select: Bool = false
    var mode: String = ""
    var cmp:String = ""
    var needel: Int = 0
    var start = CGPoint(x: 0, y: 0)
    var end = CGPoint(x: 0, y: 0)
    var bAdded: Bool = false
    var mycount: Int = 0
    var tappedMarker : GMSMarker?
    var Ads: [ads]?
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet var mapview: UIView!
    @IBOutlet weak var fldText: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if cmptype == "myads" {Ads = myAds}
        if cmptype == "nearby" {Ads = nearbyAds}
        
        self.fldText.text = Ads?[cmpId].message
        self.lblTitle.text = Ads?[cmpId].headline!.uppercased()
        
        Alamofire.request((Ads?[cmpId].logo)!).responseImage { response in
            if let image = response.result.value {
                let imageView = UIImageView(image: image)
                imageView.frame = CGRect(x: self.view.frame.width*0.375, y:self.view.frame.height*0.63, width: self.view.frame.width*0.25, height: self.view.frame.width*0.25*0.64)
                imageView.layer.masksToBounds = true
                imageView.layer.cornerRadius = 8
                imageView.layer.masksToBounds = true
                imageView.clipsToBounds = true
                imageView.tag = 102
                self.view.addSubview(imageView)
            }
        }
        
        LoadMarkers()
        
        let myColour2 = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        btnHome.frame.size.width=btnHome.frame.height
        btnHome.backgroundColor = .white
        btnHome.layer.cornerRadius = btnHome.frame.width / 2
        btnHome.layer.borderWidth = 1
        btnHome.layer.borderColor = myColour2.cgColor
        btnHome.layer.backgroundColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        let largeConfig1 = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
        let image1 = UIImage(systemName: "house.fill", withConfiguration: largeConfig1)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        btnHome.setImage(image1, for: .normal)
        btnHome.imageView?.contentMode = .scaleAspectFit
        
        btnBack.frame.size.width=btnBack.frame.height
        btnBack.backgroundColor = .white
        btnBack.layer.cornerRadius = btnBack.frame.width / 2
        btnBack.layer.borderWidth = 1
        btnBack.layer.borderColor = myColour2.cgColor
        btnBack.layer.backgroundColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        let largeConfig4 = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
        let image4 = UIImage(systemName: "arrowshape.turn.up.backward.2.fill", withConfiguration: largeConfig4)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        btnBack.setImage(image4, for: .normal)
        btnBack.imageView?.contentMode = .scaleAspectFit
    }
    
    @IBAction func btnHome(_ sender: Any) {
        self.performSegue(withIdentifier: "map_to_dashboard", sender: self)
    }
    @IBAction func btnBack(_ sender: Any) {
        self.performSegue(withIdentifier: "map_to_detail_segue", sender: self)
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        start = scrollView.contentOffset;
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        end = scrollView.contentOffset;
        if end.x>start.x {
        }
    }
   
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func LoadMarkers() {
        
        if let viewWithTag = self.view.viewWithTag(102) {viewWithTag.removeFromSuperview()}
        
        let myWidth = (UIScreen.main.bounds.width)*0.5
        let myHeight = (UIScreen.main.bounds.height)*0.80
        let x = 0.00
        let y = myHeight*0.092
        var mapView:GMSMapView?
        let mycol = UIColor(red: 230/255, green: 30/255, blue: 30/255, alpha: 1)
        
        let lat = myAds?[cmpId].outlets![0].lat
        let lon = myAds?[cmpId].outlets![0].lon
 
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height)*0.60), camera:
                                    GMSCameraPosition.camera(withLatitude: lat!, longitude: lon!, zoom: zoom))
        do {
            mapView?.mapStyle = try GMSMapStyle(jsonString: kMapStyle)
        } catch {
        }
        mapView!.tag = 102
        self.view.addSubview(mapView!)
        mapView!.delegate = self
        
        var bounds = GMSCoordinateBounds()
        if let outlets = myAds?[cmpId].outlets {
            for outlet in outlets {
                let position = CLLocationCoordinate2D(latitude: outlet.lat!, longitude: outlet.lon!)
                bounds = bounds.includingCoordinate(position)
                let marker = GMSMarker(position: position)
                marker.title = outlet.name
                marker.map = mapView
            }
            let update = GMSCameraUpdate.fit(bounds, withPadding: 50.0)
            mapView!.animate(with: update)
        }
    }
}

let kMapStyle = "[" +
    "  {" +
    "    \"featureType\": \"poi.business\"," +
    "    \"elementType\": \"all\"," +
    "    \"stylers\": [" +
    "      {" +
    "        \"visibility\": \"off\"" +
    "      }" +
    "    ]" +
    "  }," +
    "  {" +
    "    \"featureType\": \"transit\"," +
    "    \"stylers\": [" +
    "      {" +
    "        \"visibility\": \"off\"" +
    "      }" +
    "    ]" +
    "  }" +
"]"

