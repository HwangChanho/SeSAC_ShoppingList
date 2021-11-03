//
//  RealmManager.swift
//  SeSAC_ShoppingList
//
//  Created by ChanhoHwang on 2021/11/02.
//

import Foundation
import RealmSwift

class RealmManager {
    
    // static let shared = RealmManager()
    
    let localRealm = try! Realm()
    
    func removeById(index: Int) {
        print(#function)
        let list = localRealm.objects(ShoppingList.self)
        
        let filter = list.filter("id == \(index)")
        print(filter)
        
        for i in 0 ..< filter.count {
            try! localRealm.write {
                localRealm.delete(filter[i])
            }
        }
    }
    
    func create(index: Int, shoppingList: String, buyCheck: Bool, favourite: Bool) {
        print(#function)
        let task = ShoppingList(index: index, shoppingList: shoppingList, buyCheck: buyCheck, favourite: favourite)
        
        try! localRealm.write {
            localRealm.add(task)
        }
    }
    
    func updateBuyCheck(index: Int, buyCheck: Bool) {
        print(#function)
        if let list = localRealm.objects(ShoppingList.self).filter(NSPredicate(format: "index == %d", index)).first {
            print(list)
            try! localRealm.write {
                list.buyCheck = buyCheck
            }
        }
    }
    
    func updateFavourite(index: Int, favourite: Bool) {
        print(#function)
        if let list = localRealm.objects(ShoppingList.self).filter(NSPredicate(format: "index == %d", index)).first {
            print(list)
            try! localRealm.write {
                list.favourite = favourite
            }
        }
    }
    
    func deleteAll() {
        print(#function)
        try! localRealm.write {
            localRealm.deleteAll()
        }
    }
}
