//
//  ApiCallingClass.swift
//  C2C
//
//  Created by Karmick on 13/04/18.
//  Copyright © 2018 Karmick. All rights reserved.
//

import Foundation
import Alamofire
import SDLoader
import Reachability


struct APIError: Error {
    var errorCode: Int?
    var errorDetails: String?
}

class ApiCallingClass {

    
    static func BaseApiCalling(withurlString urlString: String , withParameters parameters: Parameters, withSuccess success:@escaping (_ response: (Any)) -> Void, andFailure failure:@escaping (_ error: APIError?) -> Void) {
        
        
        let reachability = Reachability()!
        
        if reachability.connection != .none {
            
            SDLoaderConfiguration.loaderConfig()
            SDLoaderConfiguration.sdLoader.startAnimating(atView: (UIApplication.shared.windows.first)!)
            
            print("Min url==\(urlString)")
            print("Parameters==\(parameters)")
            
            Alamofire.request(urlString, method:.post, parameters:parameters, encoding: URLEncoding.default).responseJSON{ response in

                let json = try? JSONSerialization.jsonObject(with: response.data!, options: [])
                if let jsonResponse = json{
                    print("response json : \(jsonResponse)")
                }
                
                let jsonStr = String.init(data: response.data!, encoding: String.Encoding.utf8)
                if let errorStr = jsonStr{
                    print("response str : \(errorStr)")
                }
                
                
                SDLoaderConfiguration.sdLoader.stopAnimation()
                
                if (response.error != nil) {
                    
                    let error = APIError(errorCode: -201, errorDetails: response.error!.localizedDescription)
                    failure (error)
                    
                } else {
                    
                    let result =  response.result.value
                    let statusCode = response.response?.statusCode
                    print("StatusCode= \(statusCode!)")
                    
                    if (statusCode == 200)
                    {
                        success(result!)
                    }
                    else
                    {
                        let error = APIError(errorCode: -202, errorDetails: "api failure")
//                        failure (response.result.error)
                        failure (error)
                    }
                    
                }//response else
                
            }//ALamofire
        }
        else
        {
            let error = APIError(errorCode: -200, errorDetails: "No network")
            failure(error)
        }
    }
    
    
    
    static func BaseApiCallingGetMethod(withurlString urlString: String, withSuccess success:@escaping (_ response: (Any)) -> Void, andFailure failure:@escaping (_ error: Error?) -> Void) {
        
        let reachability = Reachability()!
        
        if reachability.connection != .none {
            SDLoaderConfiguration.loaderConfig()
            SDLoaderConfiguration.sdLoader.startAnimating(atView: (UIApplication.shared.windows.first)!)
            
            print("Min url==\(urlString)")
            
            Alamofire.request(urlString, method:.get, encoding: URLEncoding.default).responseJSON{ response in
                
                let json = try? JSONSerialization.jsonObject(with: response.data!, options: [])
                if let jsonResponse = json{
                    print("response json : \(jsonResponse)")
                }
                
                let jsonStr = String.init(data: response.data!, encoding: String.Encoding.utf8)
                if let errorStr = jsonStr{
                    print("response str : \(errorStr)")
                }
                
                SDLoaderConfiguration.sdLoader.stopAnimation()
                
                if (response.error != nil) {
                    
                    let error = APIError(errorCode: -201, errorDetails: response.error!.localizedDescription)
                    failure (error)
                    print("eerroorr==\(response.error!.localizedDescription)")
                    
                } else {
                    
                    let result =  response.result.value
                    print("*******\(String(describing: result!))")
                    let statusCode = response.response?.statusCode
                    print("StatusCode= \(statusCode!)")
                    
                    if (statusCode == 200)
                    {
                        success(result!)
                    }
                    else
                    {
                        let error = APIError(errorCode: -202, errorDetails: "api failure")
                        failure (error)
                    }
                    
                }//response else
                
            }//ALamofire
        } else {
            let error = APIError(errorCode: -200, errorDetails: "No network")
            failure(error)
        }
    
        
    }
    
    static func requestWithImage(withurlString urlString: String, forImageOne imageDataOne: Data?, forImageTwo imageDataTwo: Data?, parameters: [String : Any], withSuccess success:@escaping (_ response: (Any)) -> Void, andFailure failure:@escaping (_ error: APIError?) -> Void) {
        
        let reachability = Reachability()!
        
        if reachability.connection != .none {
            
            SDLoaderConfiguration.loaderConfig()
            SDLoaderConfiguration.sdLoader.startAnimating(atView: (UIApplication.shared.windows.first)!)
            
            print("Min url==\(urlString)")
            
            let headers: HTTPHeaders = [
                /* "Authorization": "your_access_token",  in case you need authorization header */
                "Content-type": "multipart/form-data"
            ]
            
            Alamofire.upload(
                
                multipartFormData: { (multipartFormData) in
                    
                    for (key, value) in parameters {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                    
                    if let data_id_proof = imageDataOne{
                        multipartFormData.append(data_id_proof, withName: "id_proof", fileName: "id_proof.png", mimeType: "image/png")
                    }
                    
                    if let data_trade_licence = imageDataTwo{
                        multipartFormData.append(data_trade_licence, withName: "trade_licence", fileName: "trade_licence.png", mimeType: "image/png")
                    }
                    
            }, usingThreshold: UInt64.init(), to: urlString, method: .post, headers: headers) { (result) in
                
                print(result)
                
                switch result {
                    
                case .success(let upload,_,_ ):
                    
                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        
                        SDLoaderConfiguration.sdLoader.stopAnimation()
                        
                        switch response.result {
                            
                        case .success(let response):
                            
                            print("json : \(response)")
                            success(response)
                            break
                            
                        case .failure( _):
                            
                            let error = APIError(errorCode: -201, errorDetails: "api failure")
                            failure (error)
                            print("Webservice Error - \(error.localizedDescription)")
                            break
                        }
                        
                    }
                    
                case .failure( _):
                    
                    let error = APIError(errorCode: -201, errorDetails: "api failure")
                    failure (error)
                }
            }
            
        } else {
            let error = APIError(errorCode: -200, errorDetails: "No network")
            failure(error)
        }
            
    }//ALamofire
    
    
    static func requestWithMultipleImages(withurlString urlString: String, forImageOne imageDataOne: Data?, forImages imageArr: [Data], parameters: [String : Any], withSuccess success:@escaping (_ response: (Any)) -> Void, andFailure failure:@escaping (_ error: APIError?) -> Void) {
        
        let reachability = Reachability()!
        
        if reachability.connection != .none {
            
            SDLoaderConfiguration.loaderConfig()
            SDLoaderConfiguration.sdLoader.startAnimating(atView: (UIApplication.shared.windows.first)!)
            
            print("Min url==\(urlString)")
            
            let headers: HTTPHeaders = [
                /* "Authorization": "your_access_token",  in case you need authorization header */
                "Content-type": "multipart/form-data"
            ]
            
            Alamofire.upload(
                
                multipartFormData: { (multipartFormData) in
                    
                    for (key, value) in parameters {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                    
                    if let data_id_proof = imageDataOne{
                        multipartFormData.append(data_id_proof, withName: "seller_upload_doc", fileName: "seller_upload_doc.png", mimeType: "image/png")
                    }
                    
                    for i in 1...imageArr.count {
                        
                        print ("counter : \(i)")
                        
                        let pathName = "prop_images" + String(i)
                        let imageName = pathName + ".png"
                        
                        
                        print ("pathname : \(pathName)")
                        
                        print ("image data : \(imageArr[i-1] )")
                        
                        var imgData: Data?
                        
                        imgData = imageArr[i-1]
                        
                        print ("image data : \(imageArr[i-1])")
                        
                        multipartFormData.append(imageArr[i-1], withName: pathName, fileName: imageName, mimeType: "image/png")
                        
//                        if let data_id_proof = imageArr[i-1] {
//                            multipartFormData.append(data_id_proof, withName: pathName, fileName: imageName, mimeType: "image/png")
//                        }
                    }
            }, usingThreshold: UInt64.init(), to: urlString, method: .post, headers: headers) { (result) in
                
                print(result)
                
                switch result {
                    
                case .success(let upload,_,_ ):
                    
                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        
                        
                        print("response : \(response)")
                        
                        SDLoaderConfiguration.sdLoader.stopAnimation()
                        
                        switch response.result {
                            
                        case .success(let response):
                        
                            success(response)
                            break
                            
                        case .failure( _):
                            
                            let error = APIError(errorCode: -201, errorDetails: "api failure")
                            failure (error)
                            print("Webservice Error - \(error.localizedDescription)")
                            break
                        }
                        
                    }
                    
                case .failure( _):
                    
                    let error = APIError(errorCode: -201, errorDetails: "api failure")
                    failure (error)
                }
            }
            
        } else {
            let error = APIError(errorCode: -200, errorDetails: "No network")
            failure(error)
        }
        
    }//ALamofire
}
    

