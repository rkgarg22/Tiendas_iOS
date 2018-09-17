//
//  AlamofireWrapper.swift
//  DummyProject
//
//  Created by Apple on 13/09/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire

let baseUrl = ""
class AlamofireWrapper: NSObject {
    //MARK:- Create singleton object
    class var sharedInstance: AlamofireWrapper
    {
        struct Static
        {
            static let singleton: AlamofireWrapper = AlamofireWrapper()
        }
        return Static.singleton
    }
    
 
    //MARK: POST THROUGH MULTIPART API
    func postMultipart(action:String,param: [String:Any],imageData: Data?, onSuccess: @escaping(DataResponse<Any>) -> Void, onFailure: @escaping(Error) -> Void){
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if let data = imageData{
                multipartFormData.append(data, withName: "userImageUrl", fileName: "userImageUrl.jpeg", mimeType: "userImageUrl/png")
            }
        }, to: baseUrl+action)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print(progress)
                })
                upload.responseJSON { DataResponse in
                    if DataResponse.result.value != nil {
                        onSuccess(DataResponse)
                    }
                    else
                    {
                        print("DataResponseResultError==",DataResponse.result.error!)
                        //                        onFailure(DataResponse.result.error!)
                    }
                }
            case .failure(_):
                break
            }
        }
    }
    
    //MARK: POST API
    func post(action:String,param: [String:Any], onSuccess: @escaping(DataResponse<Any>) -> Void, onFailure: @escaping(Error) -> Void){
        
        let url : String = baseUrl+action
        print("param",param)
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON {
            (response:DataResponse<Any>) in
            switch(response.result) {
            case .success(_):
                
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    onSuccess(response)
                }
                break
            case .failure(_):
                print("error==",response.result.error!)
                //                onFailure(response.result.error!)
                
                break
            }
        }
    }
    
     //MARK: GET API
    func getApiHit(action:String, onSuccess: @escaping(DataResponse<Any>) -> Void, onFailure: @escaping(Error) -> Void){
        
        Alamofire.request(baseUrl+action).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    onSuccess(response)
                    
                }
                break
            case .failure(_):
                print("error",response.result.error!)
                //               onFailure(response.result.error!)
                break
            }
        }
    }
    
    
    
}
