

import UIKit
import Alamofire

class Alomafire: NSObject
{
    let alomafire =  Alamofire.SessionManager.default
    
    var department  = String()
    var municipio = String()
    var burrioString = String()
    var currentStatus = String()
    
    //MARK:- Create singleton object
    class var sharedInstance: Alomafire
    {
        struct Static
        {
            static let singleton: Alomafire = Alomafire()
        }
        return Static.singleton
    }
    
    //MARK:- login webservice
    func postservice (Url : String , _ parameters:[String : Any],completionHandler:  @escaping (_ success: NSDictionary?, _ error: NSError?) -> ())
    {
        let headers = [
            "Content-Type":"application/json"
        ]
        alomafire.session.configuration.timeoutIntervalForRequest = 40;
        alomafire.request(baseUrl + Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result
            {
            case .success(let value):
                // userDefault.set(response.response?.allHeaderFields["Authenticate-Token"], forKey: UserInfokey.USER_DEFAULT_ACESS_TOKEN)
                completionHandler(value as? NSDictionary, nil)
            case .failure(let error):
                completionHandler(nil, error as NSError)
            }
        }
        
    }
    
    //MARK:- post service With Image
    //MARK :- postWebservice
    func postservicewithImage (profileimg:UIImage?,Url : String,_ parameters:[String : Any],completionHandler: @escaping (NSDictionary?, Error?) -> ())
    {
        
        alomafire.session.configuration.timeoutIntervalForRequest = 120;
        alomafire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                
                multipartFormData.append(((value) as! String).data(using: String.Encoding.utf8)!, withName: key)
            }
            let data = UIImageJPEGRepresentation(profileimg!, 1.0)
            if  data != nil
            {
                multipartFormData.append(UIImageJPEGRepresentation(profileimg!, 0.25)!, withName: "profileImage", fileName: "profileImage.jpeg", mimeType: "profileImage/jpeg")
            }
            
        }, usingThreshold: UInt64.init(), to: baseUrl + Url, method: .post, headers: nil) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print(progress)
                })
                
                upload.responseJSON { response in
                    if response.result.value != nil {
                        completionHandler(response.result.value as? NSDictionary, nil)
                    }
                    else if (response.result.error != nil)
                    {
                        completionHandler(nil, response.result.error! as NSError)
                    }
                }
            case .failure(let encodingError):
                completionHandler(nil, encodingError as NSError)
            }
        }
        
    }
    
    func getservice (Urlstr : String ,completionHandler:  @escaping (_ success: NSDictionary?, _ error: NSError?) -> ())
    {
        let headers = [
            "Content-Type":"application/json"
        ]
        alomafire.session.configuration.timeoutIntervalForRequest = 40;
        alomafire.request(Urlstr, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:headers).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success(_):
                if response.result.value != nil {
                    completionHandler(response.result.value as? NSDictionary, nil)
                }
                else if (response.result.error != nil) {
                    completionHandler(nil, response.result.error! as NSError)
                }
                break;
            case .failure(let encodingError):
                completionHandler(nil, encodingError as NSError)
                break;
            }
        }
    }
    
    func getAllignedString (phrasString : String)-> String
    {
        var startingPoint = Int()
        var  returnString = String()
        let finalArray = NSMutableArray()
//        while (actualString.count > 16)
//        {
//        let prefix = String(actualString.characters.prefix(16))
//        let remainingCount = actualString.count - 16
//        actualString = String(actualString.characters.suffix(remainingCount))
//        finalArray.add(prefix)
//        }
//        if (actualString.count > 0 && actualString.count < 16)
//        {
//            finalArray.add(actualString)
//        }
//
//        print ("finalArray  are like this  \(finalArray)")
        

        let fullNameArr = phrasString.components(separatedBy: " ") as NSArray
        var lineString = String()
        for index in 0..<fullNameArr.count {
            let str = (fullNameArr.object(at: index) as! String).trimmingCharacters(in: .whitespaces)
            if (str.count == 16)
            {
                if (lineString.count > 0)
                {
                finalArray.add(lineString)
                finalArray.add(str)
                lineString = ""
                }
                else
                {
                    finalArray.add(str)
                    lineString = ""
                }
            }
            else if (str.count > 16)
            {
                if (lineString.count > 0)
                {
                    finalArray.add(lineString)
                    lineString = ""
                }
                let remainingCount = str.count - 16
                let prefix = String(str.prefix(16))
                let sufix = String(str.suffix(remainingCount))
                finalArray.add(prefix)
                finalArray.add(sufix)
            }
            else
            {
                if (str.count + lineString .count < 15 )
                {
                    lineString = lineString + " " + str
                    print(lineString)
                    if (index == fullNameArr.count - 1  )
                    {
                        finalArray.add(lineString)
                        lineString = ""
                    }
                }
                else
                {
                    finalArray.add(lineString)
                    lineString = str
                    print(index)
                    print(lineString)
                    if (index == fullNameArr.count - 1  )
                    {
                        finalArray.add(lineString)
                        lineString = ""
                    }
                }
            }
        }
        
        print(finalArray.count);
        print(startingPoint);
        switch (finalArray.count) {
        case 1: startingPoint = 8; break;
        case 2: startingPoint = 7; break;
        case 3: startingPoint = 6; break;
        case 4: startingPoint = 5; break;
        case 5: startingPoint = 4; break;
        case 6: startingPoint = 3; break;
        case 7: startingPoint = 3; break;
        case 8: startingPoint = 1; break;
        case 9: startingPoint = 4; break;
        case 10:startingPoint = 4; break;
        case 11:startingPoint = 4; break;
        case 12:startingPoint = 3; break;
        case 13:startingPoint = 3; break;
        case 14:startingPoint = 2; break;
        case 15:startingPoint = 2; break;
        default:
            startingPoint = 1; break;
        }
        if (startingPoint > 1){
            for _ in 1...(startingPoint-1)*16{
                returnString = " " + returnString
            }
        }
        for i in 0...finalArray.count-1{
            if(i != 0 && finalArray.count<=8){
                for _ in 1...16 {
                    returnString =  returnString + " "
                }
            }
            var str = (finalArray.object(at: i) as! String)
            str = str.trimmingCharacters(in: .whitespacesAndNewlines)
            if (str.count != 16){
                let length = str.count
                var leftcoulumn = 16 - length
                leftcoulumn = leftcoulumn/2
                if (length == 15){
                    leftcoulumn = 0
                }
                if (leftcoulumn > 0){
                    for _ in 1...leftcoulumn {
                        returnString =   returnString + " "
                    }
                }
                returnString = returnString  + str
                var rightColumn = 16 - length
                rightColumn = Int(ceil(CGFloat(rightColumn)/CGFloat(2)))
                if (rightColumn > 0){
                    for _ in 1...rightColumn {
                        returnString = returnString + " "
                    }
                }
            }
            else
            {
      
                returnString = returnString  + str
            }
        }
        
        let remainingCount = 256 - returnString.count;
        if (remainingCount > 0)
        {
        for _ in 1...remainingCount {
            returnString =  returnString + " "
        }
        }
        print (returnString)
        return returnString;
    }
}
