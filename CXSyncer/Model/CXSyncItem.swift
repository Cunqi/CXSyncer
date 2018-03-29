//
//  CXSyncItem.swift
//  CXSyncer
//
//  Created by Cunqi Xiao on 3/28/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import Foundation
import RealmSwift

class CXSyncItem: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var creationDate: Date = Date()
    @objc dynamic var data: Data = Data()
    @objc dynamic var dataType: String = ""
    @objc dynamic var syncStatus: Int = CXSyncStatus.unsynced.rawValue

    override static func primaryKey() -> String? {
        return "id"
    }

    override static func indexedProperties() -> [String] {
        return ["creationDate"]
    }

    static func getInstance(from item: CXSyncable) -> CXSyncItem {
        let syncItem = CXSyncItem()
        syncItem.id = item.id
        syncItem.creationDate = item.creationDate
        syncItem.data = item.data
        syncItem.dataType = item.dataType
        syncItem.syncStatus = item.syncStatus.rawValue
        return syncItem
    }

    func getOutputItem() -> CXSyncable {
        return CXSyncOutputItem(id: id, creationDate: creationDate, data: data, dataType: dataType, syncStatus: CXSyncStatus(rawValue: syncStatus)!)
    }
}

struct CXSyncOutputItem: CXSyncable {
    let id: String
    let creationDate: Date
    let data: Data
    let dataType: String
    let syncStatus: CXSyncStatus
}
