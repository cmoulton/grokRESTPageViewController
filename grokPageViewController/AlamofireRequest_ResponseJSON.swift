//
//  AlamofireRequest_ResponseJSON.swift
//  grokPageViewController
//
//  Created by Christina Moulton on 2015-08-19.
//  Copyright (c) 2015 Teak Mobile Inc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public protocol ResponseJSONObjectSerializable {
  init?(json: SwiftyJSON.JSON)
}

extension Alamofire.Request {
  public func responseArrayAtPath<T: ResponseJSONObjectSerializable>(pathToArray: [String]?, completionHandler: (NSURLRequest?, NSHTTPURLResponse?, Result<[T]>) -> Void) -> Self {
    let responseSerializer = GenericResponseSerializer<[T]> { request, response, data in
      guard let responseData = data else {
        let failureReason = "Array could not be serialized because input data was nil."
        let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
        return .Failure(data, error)
      }
      
      let jsonData:AnyObject?
      do {
        jsonData = try NSJSONSerialization.JSONObjectWithData(responseData, options: [])
      } catch  {
        return .Failure(responseData, error)
      }
      
      let json = SwiftyJSON.JSON(jsonData!)
      
      var currentJSON = json
      if let path = pathToArray {
        for pathComponent in path {
          currentJSON = currentJSON[pathComponent]
        }
      }
      
      var objects: [T] = []
      for (_, item) in currentJSON {
        if let object = T(json: item) {
          objects.append(object)
        }
      }
      return .Success(objects)
    }
    
    return response(responseSerializer: responseSerializer,
      completionHandler: completionHandler)
  }
}