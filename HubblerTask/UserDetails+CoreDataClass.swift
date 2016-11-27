//
//  UserDetails+CoreDataClass.swift
//  HubblerTask
//
//  Created by Arjun P A on 26/11/16.
//  Copyright © 2016 Arjun P A. All rights reserved.
//

import Foundation
import CoreData


public class UserDetails: NSManagedObject {
    
    private static var defaultInstance:UserDetails? = nil
    private var _queue:OperationQueue?
    private var queue:OperationQueue?{
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
    class func getContext() -> NSManagedObjectContext{
        let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.managedObjectContext
    }
    
    class func getDefaultInstance() -> CoreDataQueue{
        
        return CoreDataQueue.coreQueue

    }
    
    func delete(completion:@escaping (_ flag:Bool, _ error:Error?) -> Void){
        let defaultIns = UserDetails.getDefaultInstance()
        defaultIns.queue?.addOperation({
            var errord:Error?
            var flag:Bool = true
            UserDetails.getContext().delete(self)
            do{
                try UserDetails.getContext().save()
            }
            catch{
                print(error)
                errord = error
                flag = false
            }
            OperationQueue.main.addOperation({ 
                completion(flag,errord)
            })
            
        })
        
    }
    
    public class func getRecords(completion:@escaping (_ userDetails:[UserDetails], _ error:Error?) -> Void){
        let defaultIns = getDefaultInstance()
        
        defaultIns.queue?.addOperation({
            let request:NSFetchRequest<UserDetails> = self.fetchRequest()
            var userDetails:[UserDetails] = []
            var errord:Error?
            request.sortDescriptors = [NSSortDescriptor.init(key: "date", ascending: false)]
            do{
                userDetails = try self.getContext().fetch(request)
            }
            catch{
                errord = error
                print(error)
            }
            OperationQueue.main.addOperation {
                completion(userDetails, errord)
            }
        })
  
    }
    public class func getRecordsAsResults(completion:@escaping (_ userDetails:[UserDetailFetchResult], _ error:Error?)->Void){
        self.getRecords { (userDetails, error) in
            
            self.getDefaultInstance().queue?.addOperation({ 
                if let someError = error{
                  
                    OperationQueue.main.addOperation({ 
                         completion([], someError)
                    })
                   
                }
                else{
                    var results:[UserDetailFetchResult] = []
                    for userDetail in userDetails{
                    
                        let result = UserDetailFetchResult.init(userDetail)
                        results.append(result)
                    }
                    OperationQueue.main.addOperation({ 
                         completion(results,nil)
                    })
                   
                }
            })
        }
    }
    public class func storeRecord(_ models: [RawModel], completion:@escaping (_ status:Bool) -> Void){
        let defaultIns = getDefaultInstance()
       defaultIns.queue?.addOperation({
            let archivedData = NSKeyedArchiver.archivedData(withRootObject: models)
            let date = NSDate.init()
            var stats = true
            if let entity = NSEntityDescription.entity(forEntityName: "UserDetails", in: self.getContext()){
                let userDetails = NSManagedObject.init(entity: entity, insertInto: self.getContext()) as! UserDetails
                
                userDetails.data = archivedData as NSData?
                userDetails.date = date
                userDetails.genUniqueID = Utils.generateID()
                
                do{
                     try getContext().save()
                }
                catch{
                    stats = false
                    print(error)
                }
                OperationQueue.main.addOperation({ 
                    completion(stats)
                })
                
            }
        })
    
        
    }
}
