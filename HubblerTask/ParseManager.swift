//
//  ParseManager.swift
//  HubblerTask
//
//  Created by Arjun P A on 24/11/16.
//  Copyright © 2016 Arjun P A. All rights reserved.
//

import UIKit

class ParseManager: NSObject {
    
    private static let defaultManager = ParseManager.init()
    static let jsonInput:String = "[{\"field-name\":\"name\", \"type\":\"text\", \"required\":true,\"unique_id\":1},{\"field-name\":\"address\", \"type\":\"multiline\",\"unique_id\":3},{\"field-name\":\"gender\", \"type\":\"dropdown\", \"required\":true,\"options\":[\"male\", \"female\", \"other\"],\"unique_id\":4}]"
    
    //imitating a lazy stored property. Allows more control.
    fileprivate var _queue:OperationQueue?
    var queue:OperationQueue?{
        get{
            if self._queue == nil{
                _queue = OperationQueue.init()
            }
            return _queue
        }
        set{
            _queue = newValue
        }
    }
    fileprivate var _newQueue:OperationQueue?
    private var newQueue:OperationQueue?{
        get{
            if self._newQueue == nil{
                _newQueue = OperationQueue.init()
            }
            return _newQueue
        }
        set{
            _newQueue = newValue
        }
    }
    
    
    class func getParseStr(_ rawModels:[RawModel], completion:@escaping (_ str:String?, _ error:Error?) -> Void){
       let defaultParseManager = ParseManager.defaultManager
        
        defaultParseManager.getJsonString(rawModels, completion: completion)
        
    }
    private func getJsonString(_ rawModels:[RawModel], completion:@escaping (_ str:String?, _ error:Error?) -> Void){
        self.newQueue?.addOperation {
            var jsonArray:Dictionary<String,String> = [:]
            var errord:Error?
            var jsonStr:String?
            for model in rawModels{
                jsonArray[model.field_name] = model.userText
            }
            do{
                let data = try JSONSerialization.data(withJSONObject: jsonArray, options: JSONSerialization.WritingOptions.init(rawValue: 0))
                jsonStr = String.init(data: data, encoding: .utf8)
            }
            catch{
                errord = error
            }
            OperationQueue.main.addOperation({
                completion(jsonStr,errord)
            })
            
        }

    }
    func start(_ completion:@escaping ([RawModel], _ withError:Error?) -> Void){
        
        queue?.addOperation({
            var dataAfterParse:Array<RawModel> = []
            var errord:Error?
            do{
                if let dataAfterEncoding = ParseManager.jsonInput.data(using: .utf8){
                    let parsedData:Array<Dictionary<String,AnyObject>> = try JSONSerialization.jsonObject(with: dataAfterEncoding, options: .allowFragments) as! Array<Dictionary<String,AnyObject>>
                    for dict in parsedData{
                        let rawModel:RawModel = RawModel.init()
                        
                        rawModel.field_name = dict["field-name"] as! String
                        rawModel.type = dict["type"] as! String
                        rawModel.unique_id = dict["unique_id"] as! NSNumber
                        
                        if let isRequired = dict["required"] as? Bool{
                            rawModel.required = isRequired
                        }
                        
                        if let isMinimumPresent = dict["min"] as? NSNumber{
                            rawModel.min = isMinimumPresent
                        }
                        
                        if let isMaximumPresent = dict["max"] as? NSNumber{
                            rawModel.max = isMaximumPresent
                        }
                        if let options = dict["options"] as? Array<String>{
                            rawModel.options = options
                        }
                        
                        dataAfterParse.append(rawModel)
                    }
                    
                }
             
                
            }
            catch{
                errord = error
            }
            OperationQueue.main.addOperation({ 
                completion(dataAfterParse, errord)
            })
            
            
        })
       
    }
}
