
import UIKit

//MARK Google MAP API

let googleAPI = "AIzaSyDP7zkzOWlvtKj9g5yTnyx78CLkJydl_oQ"


// MARK: userDefault
let userDefault = UserDefaults.standard
let USER_DEFAULT_userId_Key = "userID"
let USER_DEFAULT_emailId_Key = "emailID"
let USER_DEFAULT_firstName_Key = "firstName"
let USER_DEFAULT_lastName_Key = "lastName"
let USER_DEFAULT_LOGIN_CHECK_Key = "Login"
let USER_DEFAULT_FireBaseToken = "fireBaseTokenId"
let USER_DEFAULT_PushNotificationEnable_Key = "pushNotification"
let USER_DEFAULT_LastBeacon_Key = "lastBeacon"
let USER_DEFAULT_LastDateObject_Key = "lastDateTime"
let USER_DEFAULT_IntroVideo_Key = "introVideo"

// local strings
let signoutMessage = "Are you sure want to sign out ?"
let alertText = "Alert"
let yesBtnTitle = "Yes"
let noBtnTitle = "No"
let okBtnTitle = "OK"
let cancelBtnTitle = "cancel"
let successAlertTitle = "success"
let simplyShopTitle = "Tiendas"
let cancelButtonTitle = "cancel"





func getLoginUserId() -> NSNumber {
    let usrDefault = UserDefaults.standard
    let usrId = usrDefault.value(forKey: USER_DEFAULT_userId_Key) as! NSNumber
    return usrId
}



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




func getLastDateObject() -> Date {
    let usrDefault = UserDefaults.standard
    let date = usrDefault.value(forKey: USER_DEFAULT_LastDateObject_Key) as! Date
    return date
}



