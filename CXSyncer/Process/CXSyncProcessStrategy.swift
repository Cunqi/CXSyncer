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
    public init() {}
    func sync(with item: CXSyncable, syncStorage: CXSyncStorage) {
        let success: CXSyncProcessSuccess = { item, statusCode in
            syncStorage.markAsSynced(with: item)
        }

        let failure: CXSyncProcessFailure = { item, statusCode, error in
            if 400 <= statusCode && statusCode <= 499 {
                syncStorage.markAsSyncFailureByDataIssue(with: item)
            } else if 500 <= statusCode && statusCode <= 599 {
                syncStorage.markAsSyncFailureByServerIssue(with: item)
            }
        }
        sync(with: item, success: success, failure: failure)
    }

    open func sync(with item: CXSyncable, success: @escaping CXSyncProcessSuccess, failure: @escaping CXSyncProcessFailure) {
        fatalError("this method should be overridden")
    }
}
