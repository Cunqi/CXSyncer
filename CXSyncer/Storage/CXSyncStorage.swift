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

    func submit(with item: CXSyncable) {
        realmQueue.async {
            let syncItem = CXSyncItem.getInstance(from: item)
            let realm = try! Realm()
            try! realm.write {
                realm.add(syncItem, update: true)
            }
        }
    }

    func delete(itemRef: ThreadSafeReference<CXSyncItem>) {
        realmQueue.async {
            let realm = try! Realm()
            guard let item = realm.resolve(itemRef) else {
                return
            }
            try! realm.write {
                realm.delete(item)
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
            let id = item.cxId
            let realm = try! Realm()
            let results = realm.objects(CXSyncItem.self).filter("id == '\(id)' AND syncStatus == \(CXSyncStatus.inProgress.rawValue)")
            try! realm.write {
                for item in results {
                    item.syncStatus = status.rawValue
                }
            }
        }
    }

    func removeAllData() {
        realmQueue.async {
            let realm = try! Realm()
            let result = realm.objects(CXSyncItem.self)
            try! realm.write {
                for item in result {
                    realm.delete(item)
                }
            }
        }
    }
}
