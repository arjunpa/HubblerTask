//
//  CoreDataQueue.swift
//  HubblerTask
//
//  Created by Arjun P A on 26/11/16.
//  Copyright © 2016 Arjun P A. All rights reserved.
//

import UIKit

class CoreDataQueue: NSObject {
    static let coreQueue = CoreDataQueue.init()
    private var _queue:OperationQueue?
    var queue:OperationQueue?{
        get{
            if _queue == nil{
                _queue = OperationQueue.init()
            }
            return _queue
        }
        set{
            _queue = newValue
        }
    }
    
}
