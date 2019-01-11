
import UIKit
import GoogleMaps
import Alamofire

class StoreListVC: UIViewController,CustomCalloutViewDelegate,GMSMapViewDelegate
{
    @IBOutlet weak var drawRouteView: UIView!
    @IBOutlet weak var storeListTableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var overlayView: UIView!
    var infoWindow = CustomCalloutView()
    fileprivate var locationMarker : GMSMarker? = GMSMarker()
    var controllerView = UIView()
    var storeListArray = NSMutableArray()
    var selectedmodel = listModel()
    var selectedLocation = CLLocation()
    var isFilter = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self .getlistVc();
//        NotificationCenter.default.addObserver(self, selector: #selector(StoreListVC.methodOfReceivedNotification(notification:)), name: Notification.Name("listShow"), object: nil)
    }
    
    @IBAction func wazeAction(_ sender: Any)
    {
        
        if let aString = URL(string: "waze://") {
            if UIApplication.shared.canOpenURL(aString) {
                // Waze is installed. Launch Waze and start navigation
                var urlStr = "https://waze.com/ul?ll=\(self.selectedLocation.coordinate.latitude),\(self.selectedLocation.coordinate.longitude)&navigate=yes"
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
    
    @objc func methodOfReceivedNotification(notification: Notification)
    {
        UIView.transition(with: mapView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.mapView.isHidden = true
            self.mapView .clear()
            self.infoWindow = self.loadNiB()
            self .setupMapView();
        })
    }
    
    
    
    @IBAction func cancelAction(_ sender: Any)
    {
        UIView.animate(withDuration: 0.8, animations: {
            self.bottomConstraint.constant = -300
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "openshadow"), object: nil, userInfo: ["text": "true"])
            // Some value
            self.overlayView.isHidden = true
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


//MARK:- TableView Datasource and AppDelegate
extension StoreListVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:TiendasTableViewCell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! TiendasTableViewCell
        let list = storeListArray.object(at: indexPath.row) as! listModel
        cell.listTitle.text = list.title
        cell.listAddress.text = list.address
        cell.listDistance.text = String(format: "%.2f",list.distance)
        if (list.isNew == "no"){
            cell.isnewImg.isHidden = false
        }
        else{
            cell.isnewImg.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedmodel = storeListArray.object(at: indexPath.row) as! listModel
        UIView.transition(with: mapView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.mapView.isHidden = false
            self.mapView .clear()
            self.infoWindow = self.loadNiB()
            self .setupMapView();
        })
    }
}

extension StoreListVC
{
    func loadNiB() -> CustomCalloutView {
        let infoWindow = CustomCalloutView.instanceFromNib() as! CustomCalloutView
        return infoWindow
    }
    func getlistVc()
    {
        if(applicationDelegate.isConnectedToNetwork == true)
        {
            self.view.endEditing(true)
            applicationDelegate .showActivityIndicatorView()
            
            var Urlstr = String ()
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
                            list.latitude = resultDic?.value(forKey: "latitude") as? String ?? ""
                            list.longitude = resultDic?.value(forKey: "longitude") as? String ?? ""
                            self.storeListArray.add(list);
                        }
                        self.storeListTableView.reloadData()
                    }
                    else
                    {
                        applicationDelegate .hideActivityIndicatorView()
                        
                        //self.refreshAfterloading()
                    }
                }
                else {
                    //                if (self.searchArray .count <= 0){
                    //                    self.noPhraseFound.isHidden = false}
                    
                }}
        }
        else
        {
            showAlert(self, message:connectivityMessage , title: appName)
        }
    }
    
    
    
}
///MAPView setup...
extension StoreListVC
{
    //Delegate
    func didTapInfoButton(data: listModel) {
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomConstraint.constant = 0
            self.bringSubviewToFront(view: self.overlayView)
            self.bringSubviewToFront(view: self.drawRouteView)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "openshadow"), object: nil, userInfo: ["text": "false"])
            self.overlayView.isHidden = false// Some value
            self.view.layoutIfNeeded()
        })
    }
    func bringSubviewToFront(view: UIView) {
        let superview = view.superview
        superview?.addSubview(view)
    }
    //Mark:- setupMapView...
    func setupMapView() {
        mapView.clear()
        mapView.delegate = self
        mapView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width-5, height: self.view.frame.size.height)
        let marker = GMSMarker()
        marker.icon = #imageLiteral(resourceName: "currentloc")
        marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(applicationDelegate.latitude), longitude: CLLocationDegrees(applicationDelegate.longitude))
        marker.appearAnimation = .pop
        marker.map = self.mapView
        
        //ADD DESTINATION...
        let marker1 = GMSMarker()
        marker1.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(selectedmodel.latitude)!, longitude: CLLocationDegrees(selectedmodel.longitude)!)
        marker1.appearAnimation = .pop
        marker1.map = self.mapView
        marker1.icon = #imageLiteral(resourceName: "MapLogo")
        marker1.userData = self.selectedmodel
        // Use your location
        mapView.settings.zoomGestures = true
        let camera  = GMSCameraPosition.camera(withLatitude: applicationDelegate.latitude, longitude: applicationDelegate.longitude, zoom: 6)
       // self.mapView.isMyLocationEnabled = true
        self.mapView.camera = camera

        //mapView.animate(to: camera)
    }                                                                                                                                
    
}
extension StoreListVC
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
                    if (routes .count > 0)
                    {
                        
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
        
        let dottedPolyline  = GMSPolyline(path: dotPath)
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
        applicationDelegate.hideActivityIndicatorView()
        
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        var markerData : listModel?
        //        if let data = marker.userData! as? listModel {
        //            markerData = data
        //        }
        if (marker.userData != nil)
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
}
