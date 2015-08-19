//
//  StockQuoteItems.swift
//  PullToUpdateDemo
//
//  Created by Christina Moulton on 2015-04-29.
//  Copyright (c) 2015 Teak Mobile Inc. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

/* Feed of Apple, Yahoo & Google stock prices (ask, year high & year low) from Yahoo ( https://query.yahooapis.com/v1/public/yql?q=select%20symbol%2C%20Ask%2C%20YearHigh%2C%20YearLow%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22AAPL%22%2C%20%22GOOG%22%2C%20%22YHOO%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys ) looks like
{
"query": {
"count": 3,
"created": "2015-04-29T16:21:42Z",
"lang": "en-us",
"results": {
"quote": [
{
"symbol": "AAPL"
"YearLow": "82.904",
"YearHigh": "134.540",
"Ask": "129.680"
},
...
]
}
}
}
*/
// See https://developer.yahoo.com/yql/ for tool to create queries

class StockQuoteItem: ResponseJSONObjectSerializable {
  let symbol: String?
  let ask: String?
  let yearHigh: String?
  let yearLow: String?
  
  required init?(json: SwiftyJSON.JSON) {
    println(json)
    self.symbol = json["symbol"].string
    self.ask = json["Ask"].string
    self.yearHigh = json["YearHigh"].string
    self.yearLow = json["YearLow"].string
  }
  
  class func endpointForFeed(symbols: Array<String>) -> String {
    //    let wrappedSymbols = symbols.map { $0 = "\"" + $0 + "\"" }
    let symbolsString:String = "\", \"".join(symbols)
    let query = "select * from yahoo.finance.quotes where symbol in (\"\(symbolsString) \")&format=json&env=http://datatables.org/alltables.env"
    let encodedQuery = query.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
    
    let endpoint = "https://query.yahooapis.com/v1/public/yql?q=" + encodedQuery!
    return endpoint
  }
  
  class func getFeedItems(symbols: Array<String>, completionHandler: ([StockQuoteItem]?, NSError?) -> Void) {
    Alamofire.request(.GET, self.endpointForFeed(symbols))
      .responseArrayAtPath(["query", "results", "quote"], completionHandler:{ (request, response, stocks: [StockQuoteItem]?, error) in
        completionHandler(stocks, error)
    })
  }
}
