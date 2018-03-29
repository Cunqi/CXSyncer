//
//  CXSyncOperation.swift
//  CXSyncer
//
//  Created by Cunqi Xiao on 3/29/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import Foundation

class CXSyncOperation {
    private let item: CXSyncable

    init(with item: CXSyncable) {
        self.item = item
    }

    func getOperation() -> BlockOperation {
        return BlockOperation { [weak self] in
            guard let mItem = self?.item else {
                return
            }
            let strategy = CXSyncerConfiguration.processStrategies[mItem.dataType]
            strategy?.sync(with: mItem)
        }
    }
}
