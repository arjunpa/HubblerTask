//
//  UserDetailFetchResult.swift
//  HubblerTask
//
//  Created by Arjun P A on 26/11/16.
//  Copyright © 2016 Arjun P A. All rights reserved.
//

import UIKit

public class UserDetailFetchResult: NSObject {
    
    var rawData:[RawModel] = []
    private var userDetail:UserDetails!
    var genUniqueID:String!
    
    public required init(_ userDetail:UserDetails) {
        super.init()
        self.userDetail = userDetail
        let rawDatad:[RawModel] = NSKeyedUnarchiver.unarchiveObject(with: userDetail.data as! Data) as! [RawModel]
        self.rawData = rawDatad
        self.genUniqueID = userDetail.genUniqueID
    }
    
    func delete(completion:@escaping (_ flag:Bool, _ error:Error?) -> Void){
        self.userDetail.delete(completion: completion)
    }
}


