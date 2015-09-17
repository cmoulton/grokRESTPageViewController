//
//  PersistenceManager.swift
//  grokPageViewController
//
//  Created by Christina Moulton on 2015-09-17.
//  Copyright © 2015 Teak Mobile Inc. All rights reserved.
//

import Foundation

enum Path: String {
  case StockQuotes = "StockQuotes"
}

class PersistenceManager {
  class private func documentsDirectory() -> NSString {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    let documentDirectory = paths[0] as String
    return documentDirectory
  }
  
  class func saveNSArray(arrayToSave: NSArray, path: Path) {
    let file = documentsDirectory().stringByAppendingPathComponent(path.rawValue)
    NSKeyedArchiver.archiveRootObject(arrayToSave, toFile: file)
  }
  
  class func loadNSArray(path: Path) -> NSArray? {
    let file = documentsDirectory().stringByAppendingPathComponent(path.rawValue)
    let result = NSKeyedUnarchiver.unarchiveObjectWithFile(file)
    return result as? NSArray
  }
}
