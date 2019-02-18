
import UIKit

//MARK Google MAP API


struct navigatorStatus
{
 static let ListViewSelect = "ListViewSelect"
 static let List = "List"
 static let Filter = "filter"
}


let googleAPI = "AIzaSyDP7zkzOWlvtKj9g5yTnyx78CLkJydl_oQ"

let ServiceURL = "http://ec2-18-221-191-16.us-east-2.compute.amazonaws.com/api/"
let listWebservice = "listing/?"


let appName = "Tiendas"
let connectivityMessage = "La conexión a Internet parece estar fuera de línea"
let departmentEmptyMessage = "Por favor seleccione cualquier Departamento primero"

let municipioEmptyMessage = "Por favor seleccione cualquier Municipio primero"
let selectColor: UIColor = UIColor(red: 74/255.0, green: 100/255.0, blue: 114/255.0, alpha: 1.0)

let unselectColor: UIColor = UIColor(red: 1/255.0, green: 90/255.0, blue: 158/255.0, alpha: 1.0)

let selectTextColor: UIColor = UIColor(red: 97/255.0, green: 117/255.0, blue: 123/255.0, alpha: 1.0)
let polylineColor: UIColor = UIColor(red: 192/255.0, green: 77/255.0, blue: 76/255.0, alpha: 1.0)

let userDefault = UserDefaults.standard
let USER_DEFAULT_FireBaseToken = "fireBaseTokenId"
// MARK: appDelegate reference
let applicationDelegate = UIApplication.shared.delegate as!(AppDelegate)

// MARK: showAlert Function
func showAlert (_ reference:UIViewController, message:String, title:String){
    var alert = UIAlertController()
    if title == "" {
        alert = UIAlertController(title: nil, message: message,preferredStyle: UIAlertControllerStyle.alert)
    }
    else{
        alert = UIAlertController(title: title, message: message,preferredStyle: UIAlertControllerStyle.alert)
    }
    
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    reference.present(alert, animated: true, completion: nil)
    
}








