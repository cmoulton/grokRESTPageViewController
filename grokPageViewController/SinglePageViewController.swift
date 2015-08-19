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
  var dataObject: AnyObject?
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    if let pageObject:AnyObject = dataObject {
      dataLabel.text = pageObject.description
    }
  }
}
