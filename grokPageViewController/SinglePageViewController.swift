//
//  SinglePageViewController.swift
//  grokPageViewController
//
//  Created by Christina Moulton on 2015-08-19.
//  Copyright (c) 2015 Teak Mobile Inc. All rights reserved.
//

import UIKit

class SinglePageViewController: UIViewController {
  @IBOutlet weak var dataLabel: UILabel!
  var stock: StockQuoteItem?
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    if let aSymbol = stock?.symbol, anAsk = stock?.ask, high = stock?.yearHigh, low = stock?.yearLow {
      dataLabel.text = aSymbol + ": " + anAsk + "\n" + "Year High: " + high + "\n" + "Year Low: " + low
    } else {
      dataLabel.text = stock?.symbol
    }
  }
}
