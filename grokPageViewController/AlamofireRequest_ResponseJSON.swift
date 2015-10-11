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
  public func responseArrayAtPath<T: ResponseJSONObjectSerializable>(pathToArray: [String]?, completionHandler: Response<[T], NSError> -> Void) -> Self {
    let responseSerializer = ResponseSerializer<[T], NSError> { request, response, data, error in
      guard error == nil else {
        return .Failure(error!)
      }
      guard let responseData = data else {
        let failureReason = "Array could not be serialized because input data was nil."
        let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
        return .Failure(error)
      }
      
      let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
      let result = JSONResponseSerializer.serializeResponse(request, response, responseData, error)
    
      switch result {
      case .Success(let value):
        let json = SwiftyJSON.JSON(value)
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
      case .Failure(let error):
        return .Failure(error)
      }
    }
    
    return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
  }
}