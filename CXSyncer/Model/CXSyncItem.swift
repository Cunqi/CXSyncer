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
    @objc dynamic var data: Data? = nil
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
        syncItem.id = item.cxId
        syncItem.creationDate = item.cxCreationDate
        syncItem.data = item.cxData
        syncItem.dataType = item.cxDataType
        syncItem.syncStatus = item.cxSyncStatus.rawValue
        return syncItem
    }

    func getOutputItem() -> CXSyncable {
        return CXSyncOutputItem(cxId: id, cxCreationDate: creationDate, cxData: data, cxDataType: dataType, cxSyncStatus: CXSyncStatus(rawValue: syncStatus)!)
    }
}

struct CXSyncOutputItem: CXSyncable {
    let cxId: String
    let cxCreationDate: Date
    let cxData: Data?
    let cxDataType: String
    let cxSyncStatus: CXSyncStatus
}
