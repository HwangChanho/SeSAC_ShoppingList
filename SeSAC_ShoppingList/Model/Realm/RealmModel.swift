//
//  RealmModel.swift
//  SeSAC_Week06
//
//  Created by ChanhoHwang on 2021/11/02.
//

import Foundation
import RealmSwift

/*
 let shoppingList: String
 var buyCheck: Bool
 var favourite: Bool
 */

// table
class ShoppingList: Object {
    @Persisted var index: Int // column
    @Persisted var shoppingList: String
    @Persisted var buyCheck: Bool
    @Persisted var favourite: Bool
    
    // PK
    // @Persisted var objectId: ObjectId
    @Persisted(primaryKey: true) var _id: ObjectId
    
    convenience init(index: Int, shoppingList: String, buyCheck: Bool, favourite: Bool) {
        self.init()
        self.index = index
        self.shoppingList = shoppingList
        self.buyCheck = buyCheck
        self.favourite = favourite
    }
}
