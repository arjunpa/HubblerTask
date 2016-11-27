//
//  RawModel.swift
//  HubblerTask
//
//  Created by Arjun P A on 24/11/16.
//  Copyright © 2016 Arjun P A. All rights reserved.
//

import UIKit

 public class RawModel: NSObject, NSCoding {
    

    var field_name:String!
    var type:String!
    var required:Bool = true
    var min:NSNumber?
    var max:NSNumber?
    var unique_id:NSNumber!
    var validation:Validation?
    var userText:String = ""
    var options:[String] = []
    override public var description: String{
        return "field_name:\(self.field_name)" + "," + "type:\(self.type)" + ", " + "required:\(self.required)" + ", " + "min:\(self.min)" + ", " + "max:\(self.max)" + ", " + "unique_id:\(self.unique_id)"
    }
     override init() {
       
    }
   
     public required convenience init?(coder aDecoder: NSCoder) {
        
        self.init()
      
        self.field_name = aDecoder.decodeObject(forKey: "field_name") as! String
        self.type = aDecoder.decodeObject(forKey: "type") as! String
        self.required = aDecoder.decodeBool(forKey: "required")
        self.min = aDecoder.decodeObject(forKey: "min") as? NSNumber
        self.max = aDecoder.decodeObject(forKey: "max") as? NSNumber
        self.unique_id = aDecoder.decodeObject(forKey: "unique_id") as? NSNumber
        self.userText = aDecoder.decodeObject(forKey: "userText") as! String
        self.options = aDecoder.decodeObject(forKey: "options") as! [String]
       
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(field_name, forKey: "field_name")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(required, forKey: "required")
        aCoder.encode(min, forKey: "min")
        aCoder.encode(max, forKey: "max")
        aCoder.encode(unique_id, forKey: "unique_id")
        aCoder.encode(userText, forKey: "userText")
        aCoder.encode(options, forKey: "options")
    }
}
