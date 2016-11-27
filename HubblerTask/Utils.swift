//
//  Utils.swift
//  HubblerTask
//
//  Created by Arjun P A on 24/11/16.
//  Copyright © 2016 Arjun P A. All rights reserved.
//

import UIKit

class Utils: NSObject {
   /* func cantorPair(indexPath:IndexPath) -> Int
    {
        let x:Int = indexPath.section;
    NSUInteger y = indexPath.row;
    return ((x + y) * (x + y + 1)) / 2 + y;
    }
    
    
    NSIndexPath *reverseCantorPair(NSUInteger z)
    {
    NSUInteger t = floor((-1.0f + sqrt(1.0f + 8.0f * z))/2.0f);
    NSUInteger x = t * (t + 3) / 2 - z;
    NSUInteger y = z - t * (t + 1) / 2;
    return [NSIndexPath indexPathForRow:y inSection:x];
    }
 */
    class func generateID() -> String
    {
        
        return UUID().uuidString
    }
}
