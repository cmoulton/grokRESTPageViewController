//
//  StocksDataController.swift
//  
//
//  Created by Christina Moulton on 2015-08-19.
//
//

import Foundation
import UIKit

class StocksDataController {
  var dataObjects = NSMutableArray() // NSMutableArray because Swift arrays don't have objectAtIndex
  
  func loadStockQuoteItems(completionHandler: (NSError?) -> Void) {
    let symbols = ["AAPL", "GOOG", "YHOO"]
    StockQuoteItem.getFeedItems(symbols, completionHandler:{ (result) in
      if let error = result.error {
        completionHandler(error)
        return
      }
      if let stocks = result.value {
        for stock in stocks { // because we're getting back a Swift array but it's easier to do the PageController in an NSMutableArray
          self.dataObjects.addObject(stock)
        }
      }
      // success
      completionHandler(nil)
    })
  }
  
  func indexOfStock(stock: StockQuoteItem) -> Int {
    return dataObjects.indexOfObject(stock)
  }
  
  func stockAtIndex(index: Int) -> StockQuoteItem? {
    if (index < 0 || index > dataObjects.count - 1) {
      return nil
    }
    return dataObjects[index] as? StockQuoteItem
  }
}