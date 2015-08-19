//
//  GrokPageViewController.swift
//  grokPageViewController
//
//  Created by Christina Moulton on 2015-08-19.
//  Copyright (c) 2015 Teak Mobile Inc. All rights reserved.
//

import UIKit

class GrokPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
  
  var dataObjects = NSMutableArray() // NSMutableArray because Swift arrays don't have objectAtIndex
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    self.delegate = self
    self.dataSource = self
    
    // toss in some dummy data for now
    dataObjects.addObject("Hi")
    dataObjects.addObject("Yo")
    dataObjects.addObject("Bonjour")
    
    // set first view controller to display
    if let firstVC = viewControllerAtIndex(0)
    {
      let viewControllers = [firstVC]
      self.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: UIPageViewControllerDataSource & UIPageViewControllerDelegate
  func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
    if let currentPageViewController = viewController as? SinglePageViewController, currentDataObject:AnyObject = currentPageViewController.dataObject {
      let currentIndex = dataObjects.indexOfObject(currentDataObject)
      return viewControllerAtIndex(currentIndex - 1)
    }
    return nil
  }
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    if let currentPageViewController = viewController as? SinglePageViewController, currentDataObject:AnyObject = currentPageViewController.dataObject {
      let currentIndex = dataObjects.indexOfObject(currentDataObject)
      return viewControllerAtIndex(currentIndex + 1)
    }
    return nil
  }
  
  func viewControllerAtIndex(index: Int) -> UIViewController? {
    if (index < 0 || index > dataObjects.count - 1) {
      return nil
    }
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewControllerWithIdentifier("SinglePageViewController") as! SinglePageViewController
    let dataObject:AnyObject = dataObjects[index]
    vc.dataObject = dataObject
    return vc
  }
  
}

