

import UIKit
import GoogleMaps
import CoreLocation
import Alamofire

let locationManager = CLLocationManager()
var dottedPolyline = GMSPolyline()


class ListInMapViewVC: UIViewController,CLLocationManagerDelegate,CustomCalloutViewDelegate,GMSMapViewDelegate{
    func didTapInfoButton(data: listModel)
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomConstraint.constant = 0
            self.bringSubviewToFront(view: self.overLayView)
            self.bringSubviewToFront(view: self.drawRouteView)
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "openshadow"), object: nil, userInfo: ["text": "false"])
            self.overLayView.isHidden = false
            self.view.layoutIfNeeded()
        })
    }
    func bringSubviewToFront(view: UIView) {
        let superview = view.superview
        superview?.addSubview(view)
    }
    var selectedLocation = CLLocation()
    var storeListArray = NSMutableArray()
    var infoWindow = CustomCalloutView()
    var isFilter = Bool()

    
    fileprivate var locationMarker : GMSMarker? = GMSMarker()
    @IBOutlet weak var drawRouteView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var overLayView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applicationDelegate.fetchCurrentLocation()
        self .getlistVc();
        self.infoWindow = loadNiB()
        // Do any additional setup after loading the view.
    }

    func loadNiB() -> CustomCalloutView {
        let infoWindow = CustomCalloutView.instanceFromNib() as! CustomCalloutView
        return infoWindow
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        var markerData : listModel?
//        if let data = marker.userData! as? listModel {
//            markerData = data
//        }
        if((marker.userData) != nil)
        {
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
        selectedLocation = (markerData?.placeLocation)!
        self.drawRoute(location: (markerData?.placeLocation)!)
        infoWindow.placeAddress.text = markerData?.address
        infoWindow.placeName.text = markerData?.title
        infoWindow.center = mapView.projection.point(for: location)
        infoWindow.center.y = infoWindow.center.y - 10
        infoWindow.center.x = infoWindow.center.x + 100
        self.view.addSubview(infoWindow)
        }
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
    
    
    
    //Mark :- Helping Functions
    func loadMarkersFromDB() {
        
        mapView.clear()
        mapView.delegate = self
        let marker = GMSMarker()
        mapView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)


        marker.icon = #imageLiteral(resourceName: "currentloc")
        marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(applicationDelegate.latitude), longitude: CLLocationDegrees(applicationDelegate.longitude))
        marker.appearAnimation = .pop
        marker.map = self.mapView
      

        var bounds = GMSCoordinateBounds()
        for model in storeListArray
        {
            let listmarker  = model as? listModel
            let marker = GMSMarker()
            var dLati = 0.0
            var dLong = 0.0
            if let strLat = listmarker?.latitude {
                dLati = Double((strLat as NSString).doubleValue);
            }
            if let strLong = listmarker?.longitude {
                dLong = Double((strLong as NSString).doubleValue);
            }
            marker.position = CLLocationCoordinate2D(latitude:  (dLati) , longitude:   (dLong))
            marker.appearAnimation = .pop
            marker.map = self.mapView
            marker.icon = #imageLiteral(resourceName: "MapLogo")
            marker.userData = listmarker
        }
        mapView.settings.zoomGestures = true
       // mapView.animate(toViewingAngle: 45)
        
      
        let camera  = GMSCameraPosition.camera(withLatitude: applicationDelegate.latitude, longitude: applicationDelegate.longitude, zoom: 17.0)
        
        
        self.mapView?.animate(to: camera)
               // mapView.animate(to: camera)

}
    
func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
    print("locations = \(locValue.latitude) \(locValue.longitude)")
}
    
    //Button Actions ....
    @IBAction func wazeAction(_ sender: Any)
    {
        
        if let aString = URL(string: "waze://") {
            if UIApplication.shared.canOpenURL(aString) {
                // Waze is installed. Launch Waze and start navigation
                let urlStr = "https://waze.com/ul?ll=\(self.selectedLocation.coordinate.latitude),\(self.selectedLocation.coordinate.longitude)&navigate=yes"
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
    @IBAction func cancelAction(_ sender: Any)
    {
        UIView.animate(withDuration: 0.8, animations: {
            self.bottomConstraint.constant = -300
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "openshadow"), object: nil, userInfo: ["text": "true"])
            self.overLayView.isHidden = true // Some value
            self.view.layoutIfNeeded()
        })
    }
    @IBAction func googlrMapredirectAction(_ sender: Any)
    {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(applicationDelegate.latitude),\(applicationDelegate.longitude)&zoom=14&views=traffic&q=\(self.selectedLocation.coordinate.latitude),\(self.selectedLocation.coordinate.longitude)")!, options: [:], completionHandler: nil)
        } else {
            showAlert(self, message: "Google Map is not instlled in your Phone", title: appName)
        }
    }
    
    

}
extension ListInMapViewVC
{
    func getlistVc()
    {
        if(applicationDelegate.isConnectedToNetwork == true)
        {
        self.view.endEditing(true)
        applicationDelegate .showActivityIndicatorView()
        
         var Urlstr = String ()
        let selectedIndex = tabBarController!.selectedIndex

        if (applicationDelegate.selectedTab == 1)
        {
              Urlstr  = ServiceURL + "filter/?latitude=\(applicationDelegate.latitude)&longitude=\(applicationDelegate.longitude)&departmento=\(Alomafire.sharedInstance.department)&municipio=\(Alomafire.sharedInstance.municipio)&barrio=\(Alomafire.sharedInstance.burrioString)"
        }
        else
        {
             Urlstr  = ServiceURL + "listing/?latitude=\(applicationDelegate.latitude)&longitude=\(applicationDelegate.longitude)"
        }
       
        Urlstr = Urlstr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        Alomafire.sharedInstance.getservice(Urlstr: Urlstr)
        { (Result, error) in
            if ((error) != nil)
            {
                applicationDelegate.hideActivityIndicatorView()
                let errormessage = error? .localizedDescription
                showAlert(self, message: errormessage!, title: appName)
            }
            if (error == nil)
            {
                if Result?.value(forKey: "success") as! Int == 1
                {
                    applicationDelegate .hideActivityIndicatorView()
                    
                    let result = Result?.value(forKey: "result") as! NSArray
                    
                    for dic in result
                    {
                        let resultDic = dic as? NSDictionary
                        let list : listModel = listModel()
                        list.title = resultDic?.value(forKey: "title") as? String ?? ""
                        list.address = resultDic?.value(forKey: "address") as? String ?? ""
                        list.city = resultDic?.value(forKey: "city") as? String ?? ""
                        list.distance = resultDic?.value(forKey: "distance") as! Double
                        list.isNew = resultDic?.value(forKey: "isNew") as? String ?? ""
                        list.latitude = resultDic?.value(forKey: "latitude")  as! String
                        list.longitude = resultDic?.value(forKey: "longitude") as! String
                        self.storeListArray.add(list);
                    }
                    self.loadMarkersFromDB();
                }
                else
                {
            applicationDelegate .hideActivityIndicatorView()
                }
            }
            else {
                
            }}
        }
        else
        {
           showAlert(self, message:connectivityMessage , title: appName)
        }
        }
}
extension ListInMapViewVC
{
 func drawRoute(location: CLLocation) {
            
            var directionURL =  "https://maps.googleapis.com/maps/api/directions/json?origin=\(applicationDelegate.latitude),\(applicationDelegate.longitude)&destination=\(location.coordinate.latitude),\(location.coordinate.latitude)&key=AIzaSyARoB09HGFjDy3IKfLpZq-ZQd3YwUT-3_E"
            
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
                        if (routes.count > 0)
                        {
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
            
        }
        func addPolyLine(encodedString: String, coordinate: CLLocationCoordinate2D ,dotCoordinate : CLLocationCoordinate2D) {
            
            //--------Dash line to connect starting point---------\\
            
            let dotPath :GMSMutablePath = GMSMutablePath()
            // add coordinate to your path
            dotPath.add(CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude))
            dotPath.add(CLLocationCoordinate2DMake(dotCoordinate.latitude, dotCoordinate.longitude))
            dottedPolyline.map = nil;
            dottedPolyline  = GMSPolyline(path: dotPath)
            dottedPolyline.map = self.mapView
            dottedPolyline.strokeWidth = 3.0
            let styles: [Any] = [GMSStrokeStyle.solidColor(polylineColor), GMSStrokeStyle.solidColor(UIColor.clear)]
            let lengths: [Any] = [10, 10]
            dottedPolyline.spans = GMSStyleSpans(dottedPolyline.path!, styles as! [GMSStrokeStyle], lengths as! [NSNumber], GMSLengthKind.rhumb)
            
            //---------Route Polyline---------\\
            
            let path = GMSMutablePath(fromEncodedPath: encodedString)
            let polyline = GMSPolyline(path: path)
            polyline.strokeWidth = 5
            polyline.strokeColor = .clear
            polyline.map = self.mapView
            
        }
}
