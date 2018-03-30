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
    let syncOperationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = CXSyncerConfiguration.maxConcurrentOperationCount
        return queue
    }()

    var unsyncedNotificationToken: NotificationToken?
    var syncedNotificationToken: NotificationToken?
    private let storage: CXSyncStorage

    init(storage: CXSyncStorage) {
        self.storage = storage

        let realm = try! Realm()
        let unsyncedResults = realm.objects(CXSyncItem.self).filter("syncStatus == \(CXSyncStatus.unsynced.rawValue)")
        let syncedResults = realm.objects(CXSyncItem.self).filter("syncStatus == \(CXSyncStatus.synced.rawValue)")

        unsyncedNotificationToken = unsyncedResults.observe { [weak self] change in
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

        syncedNotificationToken = syncedResults.observe { [weak self] change in
            switch change {
            case .initial(let initialResults):
                for item in initialResults {
                    self?.removeSyncItem(for: item)
                }
            case let .update(updatedResults, _, insertions, _):
                for index in insertions {
                    self?.removeSyncItem(for: updatedResults[index])
                }
            default:
                break
            }
        }
    }

    private func removeSyncItem(for item: CXSyncItem) {
        let itemRef = ThreadSafeReference(to: item)
        self.storage.delete(itemRef: itemRef)
    }

    private func processSyncItem(for item: CXSyncItem) {
        updateSyncStatus(for: item, with: .inProgress)
        let outputItem = item.getOutputItem()
        let operation = CXSyncOperation.getOperation(for: outputItem, with: storage)
        syncOperationQueue.addOperation(operation)
    }

    private func updateSyncStatus(for item: CXSyncItem, with status: CXSyncStatus) {
        let itemRef = ThreadSafeReference(to: item)
        syncQueue.async {
            let realm = try! Realm()
            guard let item = realm.resolve(itemRef) else {
                return
            }
            try! realm.write {
                item.syncStatus = status.rawValue
            }
        }
    }

    func retrySyncing(reason: CXSyncStatus) {
        syncQueue.async { [weak self] in
            let realm = try! Realm()
            let failureResults = realm.objects(CXSyncItem.self).filter("syncStatus == \(reason.rawValue)")
            for item in failureResults {
                self?.processSyncItem(for: item)
            }
        }
    }

    deinit {
        unsyncedNotificationToken?.invalidate()
    }
}
