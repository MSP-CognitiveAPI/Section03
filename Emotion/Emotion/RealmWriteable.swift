//
//  RealmWriteable.swift
//  Emotion
//
//  Created by BumMo Koo on 2016. 11. 12..
//  Copyright © 2016년 BumMo Koo. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmWriteable {
    
}

extension RealmWriteable where Self: Object {
    @discardableResult
    func update() -> Bool {
        do {
            let realm = try Realm()
            try realm.write({ 
                realm.add(self, update: true)
            })
            return true
        } catch {
            return false
        }
    }
}
