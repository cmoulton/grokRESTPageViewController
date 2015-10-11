//
//  GrokPageViewController.swift
//  grokPageViewController
//
//  Created by Christina Moulton on 2015-08-19.
//  Copyright (c) 2015 Teak Mobile Inc. All rights reserved.
//

import UIKit

class GrokPageViewController: UIPageViewController, UIPageViewControllerDataSource {
  let dataController = StocksDataController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    self.dataSource = self

    // show progress indicator or some indication that we're doing something
    // by loading an initial single view controller with a placeholder view
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let placeholderVC = storyboard.instantiateViewControllerWithIdentifier("PlaceHolderViewController") 
    self.setViewControllers([placeholderVC], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    
    dataController.loadStockQuoteItems{ (error) in
      if error != nil {
        let alert:UIAlertController
        if let description = error?.localizedDescription {
          alert = UIAlertController(title: "Error", message: "Could not load stock quotes \(description)", preferredStyle: UIAlertControllerStyle.Alert)
        } else {
          alert = UIAlertController(title: "Error", message: "Could not load stock quotes", preferredStyle: UIAlertControllerStyle.Alert)
        }
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
      } else {
        // set first view controller to display
        if let firstVC = self.viewControllerAtIndex(0) {
          let viewControllers = [firstVC]
          self.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
      }
    }
  }
  
  // MARK: UIPageViewControllerDataSource & UIPageViewControllerDelegate
  func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
    if let currentPageViewController = viewController as? SinglePageViewController, currentStock:StockQuoteItem = currentPageViewController.stock {
      let currentIndex = dataController.indexOfStock(currentStock)
      return viewControllerAtIndex(currentIndex - 1)
    }
    return nil
  }
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    if let currentPageViewController = viewController as? SinglePageViewController, currentStock:StockQuoteItem = currentPageViewController.stock {
      let currentIndex = dataController.indexOfStock(currentStock)
      return viewControllerAtIndex(currentIndex + 1)
    }
    return nil
  }

  func viewControllerAtIndex(index: Int) -> UIViewController? {
    if let stock = dataController.stockAtIndex(index) {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let vc = storyboard.instantiateViewControllerWithIdentifier("SinglePageViewController") as! SinglePageViewController
      vc.stock = stock
      return vc
    }
    return nil
  }
}
