//
//  CXSyncable.swift
//  CXSyncer
//
//  Created by Cunqi Xiao on 3/28/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import Foundation

public enum CXSyncStatus: Int {
    case unsynced
    case inProgress
    case synced
    case syncFailedByServerIssue
    case syncFailedByDataIssue
}

public protocol CXSyncable {
    var id: String { get }
    var creationDate: Date { get }
    var data: Data? { get }
    var dataType: String { get }
    var syncStatus: CXSyncStatus { get }
}

public extension CXSyncable {
    var id: String {
        return UUID().uuidString
    }

    var creationDate: Date {
        return Date()
    }

    var dataType: String {
        return "CXSyncNoneType"
    }

    var syncStatus: CXSyncStatus {
        return .unsynced
    }
}
