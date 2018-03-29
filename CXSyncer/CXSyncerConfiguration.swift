//
//  CXSyncerConfiguration.swift
//  CXSyncer
//
//  Created by Cunqi Xiao on 3/28/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import Foundation

public typealias CXSyncDataType = String

public class CXSyncerConfiguration {
    static var processStrategies = [CXSyncDataType: CXSyncProcessStrategy]()
}
