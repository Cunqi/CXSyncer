//
//  CXSyncGuard.swift
//  CXSyncer
//
//  Created by Cunqi Xiao on 3/28/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import Foundation
import RealmSwift

class CXSyncGuard {
    let syncQueue = DispatchQueue(label: "CXSyncQueue")
    let syncOperationQueue = OperationQueue()
    let cleanupQueue = DispatchQueue(label: "CXCleanupQueue")

    var notificationToken: NotificationToken? = nil

    init() {
        syncQueue.async { [weak self] in
            let realm = try! Realm()
            let results = realm.objects(CXSyncItem.self).filter("syncStatus == 0")

            self?.notificationToken = results.observe { change in
                switch change {
                case .initial(let initialResults):
                    for item in initialResults {
                        self?.processSyncItem(for: item)
                    }
                case let .update(updatedResults, _, insertions, _):
                    for index in insertions {
                        self?.processSyncItem(for: updatedResults[index])
                    }
                default:
                    break
                }
            }
        }
    }

    private func processSyncItem(for item: CXSyncItem) {
        updateSyncStatus(for: item, with: .inProgress)
        let outputItem = item.getOutputItem()
        let operation = CXSyncOperation(with: outputItem).getOperation()
        syncOperationQueue.addOperation(operation)
    }

    func updateSyncStatus(for item: CXSyncItem, with status: CXSyncStatus) {
        syncQueue.async {
            let realm = try! Realm()
            try! realm.write {
                item.syncStatus = status.rawValue
            }
        }
    }

    deinit {
        notificationToken?.invalidate()
    }
}
