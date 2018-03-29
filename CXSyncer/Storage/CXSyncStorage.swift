//
//  CXSyncStorage.swift
//  CXSyncer
//
//  Created by Cunqi Xiao on 3/28/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import Foundation
import RealmSwift

class CXSyncStorage {
    let realmQueue = DispatchQueue(label: "CXRealmQueue")
    let syncGuard: CXSyncGuard


    init(with syncGuard: CXSyncGuard) {
        self.syncGuard = syncGuard
    }

    func submit(with item: CXSyncable) {
        realmQueue.async {
            let syncItem = CXSyncItem.getInstance(from: item)
            let realm = try! Realm()
            try! realm.write {
                realm.add(syncItem, update: true)
            }
        }
    }

    func markAsSynced(with item: CXSyncable) {
        mark(item: item, with: .synced)
    }

    func markAsSyncFailureByDataIssue(with item: CXSyncable) {
        mark(item: item, with: .syncFailedByDataIssue)
    }

    func markAsSyncFailureByServerIssue(with item: CXSyncable) {
        mark(item: item, with: .syncFailedByServerIssue)
    }

    private func mark(item: CXSyncable, with status: CXSyncStatus) {
        realmQueue.async {
            let id = item.id
            let realm = try! Realm()
            let results = realm.objects(CXSyncItem.self).filter("id == '\(id)' AND syncStatus == 0")
            try! realm.write {
                for item in results {
                    item.syncStatus = status.rawValue
                }
            }
        }
    }
}
