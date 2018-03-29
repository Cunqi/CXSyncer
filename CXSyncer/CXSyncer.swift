//
//  CXSyncer.swift
//  CXSyncer
//
//  Created by Cunqi Xiao on 3/28/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import Foundation

public class CXSyncer {
    static let shared = CXSyncer()

    let storage: CXSyncStorage

    init() {
        storage = CXSyncStorage(with: CXSyncGuard())
    }

    func submit(_ item: CXSyncable) {

    }
}
