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
  public func responseArrayAtPath<T: ResponseJSONObjectSerializable>(pathToArray: [String]?, completionHandler: (NSURLRequest, NSHTTPURLResponse?, [T]?, NSError?) -> Void) -> Self {
    let responseSerializer = GenericResponseSerializer<[T]> { request, response, data in
      if let responseData = data
      {
        var jsonError: NSError?
        let jsonData:AnyObject? = NSJSONSerialization.JSONObjectWithData(responseData, options: nil, error: &jsonError)
        if jsonData == nil || jsonError != nil
        {
          return (nil, jsonError)
        }
        var objects: [T] = []
        let json = SwiftyJSON.JSON(jsonData!)
        var currentJSON = json
        if let path = pathToArray {
          for pathComponent in path {
            currentJSON = currentJSON[pathComponent]
          }
        }
        for (index, item) in currentJSON {
          if let object = T(json: item)
          {
            objects.append(object)
          }
        }
        return (objects, nil)
      }
      // TODO: handle & return appropriate error(s)
      return (nil, nil)
    }
    
    return response(responseSerializer: responseSerializer,
      completionHandler: completionHandler)
  }
}