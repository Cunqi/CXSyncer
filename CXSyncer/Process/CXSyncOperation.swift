//
//  CXSyncOperation.swift
//  CXSyncer
//
//  Created by Cunqi Xiao on 3/29/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import Foundation

class CXSyncOperation {
    static func getOperation(for item: CXSyncable, with storage: CXSyncStorage) -> BlockOperation {
        return BlockOperation {
            let strategy = CXSyncerConfiguration.processStrategies[item.cxDataType] ?? CXSyncerConfiguration.defaultStrategy
            strategy?.sync(with: item, syncStorage: storage)
        }
    }
}
