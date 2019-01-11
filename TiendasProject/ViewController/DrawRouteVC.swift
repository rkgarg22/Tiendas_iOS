
import UIKit
import GoogleMaps
import Alamofire

class DrawRouteVC: UIViewController,GMSMapViewDelegate,CustomCalloutViewDelegate {
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var location = CLLocation()
    @IBOutlet weak var mapView: GMSMapView!
    var infoWindow = CustomCalloutView()
    fileprivate var locationMarker : GMSMarker? = GMSMarker()
    
    var list : listModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadMarkers()
         self.infoWindow = loadNiB()

        // Do any additional setup after loading the view.
    }
    func loadNiB() -> CustomCalloutView {
        let infoWindow = CustomCalloutView.instanceFromNib() as! CustomCalloutView
        return infoWindow
    }
    @IBAction func backAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true);
    }
    @IBAction func cancelAction(_ sender: Any)
    {
        UIView.animate(withDuration: 0.8, animations: {
            self.bottomConstraint.constant = -300 // Some value
            self.view.layoutIfNeeded()
        })
    }
    @IBAction func googlrMapredirectAction(_ sender: Any)
    {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(applicationDelegate.latitude),\(applicationDelegate.longitude)&zoom=14&views=traffic&q=\(self.location.coordinate.latitude),\(self.location.coordinate.longitude)")!, options: [:], completionHandler: nil)
        } else {
           showAlert(self, message: "Google Map is not instlled in your Phone", title: appName)
        }
    }
        
    
    
    @IBAction func wazeAction(_ sender: Any)
    {
        
        if let aString = URL(string: "waze://") {
            if UIApplication.shared.canOpenURL(aString) {
                // Waze is installed. Launch Waze and start navigation
                var urlStr = "https://waze.com/ul?ll=\(self.location.coordinate.latitude),\(self.location.coordinate.longitude)&navigate=yes"
                if let aStr = URL(string: urlStr) {
                    
                    UIApplication.shared.open(aStr, options: [:], completionHandler: nil)
                }
            } else {
                // Waze is not installed. Launch AppStore to install Waze app
                if let aString = URL(string: "http://itunes.apple.com/us/app/id323229106") {
                    UIApplication.shared.open(aString, options: [:], completionHandler: nil)
                }
            }
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Delegate
    func didTapInfoButton(data: listModel) {
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomConstraint.constant = 0 // Some value
            self.view.layoutIfNeeded()
        })
    }
    
    func loadMarkers() {
        mapView.clear()
        mapView.delegate = self
        let marker = GMSMarker()
        marker.icon = #imageLiteral(resourceName: "currentloc")
        marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(applicationDelegate.latitude), longitude: CLLocationDegrees(applicationDelegate.longitude))
        marker.appearAnimation = .pop
        marker.map = self.mapView
        let camera  = GMSCameraPosition.camera(withLatitude: applicationDelegate.latitude, longitude: applicationDelegate.longitude, zoom: 6)
        //let m = Double
       // self.mapView.isMyLocationEnabled = true
        self.mapView.camera = camera

        

      //  mapView.animate(to: camera)
        
        
        //ADD DESTINATION...
        let name  = list?.address
        let address =  (list?.address)! + (list?.city)!
        let geoCoder = CLGeocoder()
      
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            if (error == nil)
            {
                let placemarks = placemarks,
                location = placemarks?.first?.location
                let marker = GMSMarker()
                let placeLat = location?.coordinate.latitude
                self.location = (placemarks?.first?.location)!
                
                let placeLon = location?.coordinate.longitude
                //  marker.icon = #imageLiteral(resourceName: "MapPin")
                self.drawRoute(location: location!)
                marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(placeLat!), longitude: CLLocationDegrees(placeLon!))
                marker.appearAnimation = .pop
                marker.map = self.mapView
                marker.userData = self.list
            }
            else {
                // handle no location found
                return
            }
            
            // Use your location
        }
    }

}
extension DrawRouteVC
{
    func drawRoute(location: CLLocation) {
        
        var directionURL =  "https://maps.googleapis.com/maps/api/directions/json?origin=\(applicationDelegate.latitude),\(applicationDelegate.longitude)&destination=\(location.coordinate.latitude),\(location.coordinate.latitude)&key=AIzaSyAajDW81YlRzoY0PPXBlSUxchAJ7FpBQIw"
        
        //AIzaSyDxSgGQX6jrn4iq6dyIWAKEOTneZ3Z8PtU
        
        directionURL += "&mode=" + "walking"
        
        print("drawRoute")
        
        
        Alamofire.request(directionURL).responseJSON
            { response in
                
                if let JSON = response.result.value {
                    
                    let mapResponse: [String: AnyObject] = JSON as! [String : AnyObject]
                    
                    let routesArray = (mapResponse["routes"] as? Array) ?? []
                    
                    let routes = (routesArray.first as? Dictionary<String, AnyObject>) ?? [:]
                    //print("routes : \(routes)")
                    
                    //--------Dash line lat-long for starting point ----------\\
                    
                    let dictArray = (routes["legs"] as? Array) ?? []
                    let dict = (dictArray.first as? Dictionary<String, AnyObject>) ?? [:]
                    let steps = (dict["steps"] as? Array) ?? []
                    let stepsDict = (steps.first as? Dictionary<String, AnyObject>) ?? [:]
                    
                    let startLocation = stepsDict["start_location"]
                    let lat = startLocation!["lat"] as! NSNumber
                    let lng = startLocation!["lng"] as! NSNumber
                    print("lat : \(lat) lng : \(lng)")
                    
                    let dotCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lng))
                    
                    //--------Route polypoints----------\\
                    let overviewPolyline = (routes["overview_polyline"] as? Dictionary<String,AnyObject>) ?? [:]
                    let polypoints = (overviewPolyline["points"] as? String) ?? ""
                    let line  = polypoints
                    let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    self.addPolyLine(encodedString: line, coordinate:coordinate , dotCoordinate:dotCoordinate)
                }
        }
        
    }
    func addPolyLine(encodedString: String, coordinate: CLLocationCoordinate2D ,dotCoordinate : CLLocationCoordinate2D) {
        
        //--------Dash line to connect starting point---------\\
        
        let dotPath :GMSMutablePath = GMSMutablePath()
        // add coordinate to your path
        dotPath.add(CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude))
        dotPath.add(CLLocationCoordinate2DMake(dotCoordinate.latitude, dotCoordinate.longitude))
        
        let dottedPolyline  = GMSPolyline(path: dotPath)
        dottedPolyline.map = self.mapView
        dottedPolyline.strokeWidth = 3.0
        let styles: [Any] = [GMSStrokeStyle.solidColor(UIColor.blue), GMSStrokeStyle.solidColor(UIColor.clear)]
        let lengths: [Any] = [10, 10]
        dottedPolyline.spans = GMSStyleSpans(dottedPolyline.path!, styles as! [GMSStrokeStyle], lengths as! [NSNumber], GMSLengthKind.rhumb)
        
        //---------Route Polyline---------\\
        
        let path = GMSMutablePath(fromEncodedPath: encodedString)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 5
        polyline.strokeColor = .clear
        polyline.map = self.mapView
        
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        var markerData : listModel?
        //        if let data = marker.userData! as? listModel {
        //            markerData = data
        //        }
        markerData = marker.userData as! listModel
        locationMarker = marker
        infoWindow.removeFromSuperview()
        infoWindow = loadNiB()
        guard let location = locationMarker?.position else {
            print("locationMarker is nil")
            return false
        }
        infoWindow.spotData = markerData
        infoWindow.delegate = self
        // Configure UI properties of info window
        infoWindow.alpha = 0.9
        
        infoWindow.placeAddress.text = markerData?.address
        infoWindow.placeName.text = markerData?.title
        infoWindow.center = mapView.projection.point(for: location)
        infoWindow.center.y = infoWindow.center.y - 10
        infoWindow.center.x = infoWindow.center.x + 100
        self.view.addSubview(infoWindow)
        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if (locationMarker != nil){
            guard let location = locationMarker?.position else {
                print("locationMarker is nil")
                return
            }
            infoWindow.center = mapView.projection.point(for: location)
            infoWindow.center.y = infoWindow.center.y - 10
            infoWindow.center.x = infoWindow.center.x + 100
            
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        infoWindow.removeFromSuperview()
    }
    
}
