//
//  CXSyncProcessStrategy.swift
//  CXSyncer
//
//  Created by Cunqi Xiao on 3/29/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import Foundation

public typealias CXSyncStatusCode = Int

public typealias CXSyncProcessSuccess = (CXSyncable, CXSyncStatusCode) -> Void

public typealias CXSyncProcessFailure = (CXSyncable, CXSyncStatusCode, Error?) -> Void

//public protocol CXSyncProcessStrategy {
//    func sync(with item: CXSyncable, success: @escaping CXSyncProcessSuccess, failure: @escaping CXSyncProcessFailure)
//}

open class CXSyncProcessStrategy {
    private let syncStorage: CXSyncStorage

    init(storage: CXSyncStorage) {
        self.syncStorage = storage
    }

    func sync(with item: CXSyncable) {
        let success: CXSyncProcessSuccess = { [weak self] item, statusCode in
            self?.syncStorage.markAsSynced(with: item)
        }

        let failure: CXSyncProcessFailure = { [weak self] item, statusCode, error in
            if 400 <= statusCode && statusCode <= 499 {
                self?.syncStorage.markAsSyncFailureByDataIssue(with: item)
            } else if 500 <= statusCode && statusCode <= 599 {
                self?.syncStorage.markAsSyncFailureByServerIssue(with: item)
            }
        }
        sync(with: item, success: success, failure: failure)
    }

    public func sync(with item: CXSyncable, success: @escaping CXSyncProcessSuccess, failure: @escaping CXSyncProcessFailure) {
        fatalError("this method should be overridden")
    }
}
