//
//  RestClient.swift
//  odinioswallet
//
//  Created by Waleed Khaled on 20/07/2018.
//  Copyright © 2018 Waleed Khaled. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class RestClient {
    static func postRequest(method:HTTPMethod,url:String,header:[String: String],parameters:[String: Any]?,completion: @escaping ((_ data: JSON) -> Void))
    {
        URLCache.shared.removeAllCachedResponses()
        let urlString=K.ProductionServer.baseURL+url
        var swiftyJsonVar:JSON = nil
        let recupJsonSync = Alamofire.SessionManager.default
            .requestWithoutCache(urlString, method: method, parameters: parameters,encoding: JSONEncoding.default,headers: header).responseJSON() { (responseData) -> Void in
            if((responseData.result.value) != nil) {
               swiftyJsonVar = JSON(responseData.result.value!)
               completion(swiftyJsonVar)
            }
            else{
                completion(nil)
            }
            
        }
    }

    static func multipartKYCRequest(url:String,header:[String: String],parameters:Dictionary<String, String>,numberParameters:Dictionary<String, Int>,image1: UIImage,image2: UIImage,image3: UIImage,completion: @escaping ((_ data: JSON) -> Void))
    {
        let urlString=K.ProductionServer.baseURL+url
        var swiftyJsonVar:JSON = nil
        let imageData1 = UIImageJPEGRepresentation(image1, 0.5)!
        let imageData2 = UIImageJPEGRepresentation(image2, 0.5)!
        let imageData3 = UIImageJPEGRepresentation(image3, 0.5)!
        Alamofire.upload(multipartFormData: { multipartFormData in
            // import image to request
            
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: .utf8)!, withName: key)
            }
            for (key, value) in numberParameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            multipartFormData.append(imageData1, withName: "img_front", fileName: "image.jpg", mimeType: "image/jpeg")
            multipartFormData.append(imageData2, withName: "img_back", fileName: "image.jpg", mimeType: "image/jpeg")
            multipartFormData.append(imageData3, withName: "img_selfie", fileName: "image.jpg", mimeType: "image/jpeg")
        }, to: urlString,method: .put,headers: header,
           
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if((response.result.value) != nil) {
                        swiftyJsonVar = JSON(response.result.value!)
                        completion(swiftyJsonVar)
                    }
                    else{
                        completion(nil)
                    }
                }
            case .failure(let error):
                print(error)
            }
            
        })
    }
    

}
extension Alamofire.SessionManager{
    @discardableResult
    open func requestWithoutCache(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)// also you can add URLRequest.CachePolicy here as parameter
        -> DataRequest
    {
        do {
            var urlRequest = try URLRequest(url: url, method: method, headers: headers)
            urlRequest.cachePolicy = .reloadIgnoringCacheData // <<== Cache disabled
            let encodedURLRequest = try encoding.encode(urlRequest, with: parameters)
            return request(encodedURLRequest)
        } catch {
            // TODO: find a better way to handle error
            print(error)
            return request(URLRequest(url: URL(string: "http://example.com/wrong_request")!))
        }
    }
}
