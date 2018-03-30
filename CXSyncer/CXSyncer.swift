//
//  CXSyncer.swift
//  CXSyncer
//
//  Created by Cunqi Xiao on 3/28/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import Foundation

public class CXSyncer {
    public static let shared = CXSyncer()

    let storage: CXSyncStorage
    let syncGuard: CXSyncGuard

    init() {
        storage = CXSyncStorage()
        syncGuard = CXSyncGuard(storage: storage)
    }

    public func submit(_ item: CXSyncable) {
        storage.submit(with: item)
    }

    public func retrySyncingForServerFailure() {
        syncGuard.retrySyncing(reason: .syncFailedByServerIssue)
    }

    public func retrySyncingForDataIssue() {
        syncGuard.retrySyncing(reason: .syncFailedByDataIssue)
    }
}
