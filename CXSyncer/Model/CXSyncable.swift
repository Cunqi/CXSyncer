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
    var cxId: String { get }
    var cxCreationDate: Date { get }
    var cxData: Data? { get }
    var cxDataType: String { get }
    var cxSyncStatus: CXSyncStatus { get }
}

public extension CXSyncable {
    var cxId: String {
        return UUID().uuidString
    }

    var cxCreationDate: Date {
        return Date()
    }

    var cxDataType: String {
        return String(describing: self)
    }

    var cxSyncStatus: CXSyncStatus {
        return .unsynced
    }
}
