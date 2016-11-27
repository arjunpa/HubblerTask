//
//  ValidationManager.swift
//  HubblerTask
//
//  Created by Arjun P A on 25/11/16.
//  Copyright © 2016 Arjun P A. All rights reserved.
//

import UIKit

class ValidationManager: NSObject {

    class func validate(rawData:RawModel, text:String, completion:(_ validation:Validation?) -> Void){
        
        let trimmedStr:String = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    
        if !rawData.required && trimmedStr != ""{
            completion(nil)
            return
        }
        
          let validation:Validation = Validation.init()
        if trimmedStr == ""{
            validation.message = "The \(rawData.field_name!) cannot be empty"
            validation.code = 1104
            completion(validation)
            return
        }
        
       
        if rawData.type == "number"{
            if let value = Int(trimmedStr){
                if let minimum = rawData.min , rawData.max != nil{
                    if value >= minimum.intValue && value <= rawData.max!.intValue{
                        completion(nil)
                        return
                    }
                    else{
                        validation.message = "The \(rawData.field_name!) you have entered should be between \(minimum.intValue) & \(rawData.max!.intValue)"
                        validation.code = 1104
                        completion(validation)
                        return
                    }
                }
                if let minimum = rawData.min{
                    if value < minimum.intValue{
                        validation.message = "The \(rawData.field_name!) you have entered should be at least \(minimum.intValue)"
                        validation.code = 1104
                        completion(validation)
                        return
                    }
                }
                else if let maximum = rawData.max{
                    if value > maximum.intValue{
                        validation.message = "The \(rawData.field_name!) you have entered should not be more than \(maximum.intValue)"
                        validation.code = 1104
                        completion(validation)
                        return
                    }

                }
                
            }
            
            else if rawData.type == "text" || rawData.type == "multiline"{
                let value = text.characters.count
                if let minimum = rawData.min , rawData.max != nil{
                    if value >= minimum.intValue && value <= rawData.max!.intValue{
                        completion(nil)
                        return
                    }
                    else{
                        validation.message = "The \(rawData.field_name!) you have entered should be between \(minimum.intValue) & \(rawData.max!.intValue) number of characters"
                        validation.code = 1104
                        completion(validation)
                        return
                    }
                }
                if let minimum = rawData.min{
                    if value < minimum.intValue{
                        validation.message = "The \(rawData.field_name!) you have entered should be at least \(minimum.intValue) number of characters"
                        validation.code = 1104
                        completion(validation)
                        return
                    }
                }
                else if let maximum = rawData.max{
                    if value > maximum.intValue{
                        validation.message = "The \(rawData.field_name!) you have entered should not be more than \(maximum.intValue) number of characters"
                        validation.code = 1104
                        completion(validation)
                        return
                    }
                    
                }
            }
            
            else{
                validation.message = "The \(rawData.field_name!) you have entered is not valid"
                validation.code = 1104
                completion(validation)
            }
        }
        completion(nil)
    }
    
}
