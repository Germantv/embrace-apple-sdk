//
//  Copyright © 2023 Embrace Mobile, Inc. All rights reserved.
//

import Foundation
import EmbraceStorage
import EmbraceCommon

struct SessionInfoPayload: Codable {
    let sessionId: SessionIdentifier
    let startTime: Int
    let endTime: Int?
    let lastHeartbeatTime: Int
    let appState: String
    let sessionType: String = "en"
    let counter: Int
    let appTerminated: Bool
    let cleanExit: Bool
    let coldStart: Bool
    let crashReportId: String?
    let properties: [String: String]

    enum CodingKeys: String, CodingKey {
        case sessionId = "id"
        case startTime = "st"
        case endTime = "et"
        case lastHeartbeatTime = "ht"
        case appState = "as"
        case sessionType = "ty"
        case counter = "sn"
        case appTerminated = "tr"
        case cleanExit = "ce"
        case coldStart = "cs"
        case crashReportId = "ri"
        case properties = "sp"
    }

    ///
    init(from sessionRecord: SessionRecord, metadata: [MetadataRecord], counter: Int) {
        self.sessionId = sessionRecord.id
        self.startTime = sessionRecord.startTime.millisecondsSince1970Truncated
        self.endTime = sessionRecord.endTime?.millisecondsSince1970Truncated
        self.lastHeartbeatTime = sessionRecord.lastHeartbeatTime.millisecondsSince1970Truncated
        self.appState = sessionRecord.state
        self.counter = counter
        self.appTerminated = sessionRecord.appTerminated
        self.cleanExit = sessionRecord.cleanExit
        self.coldStart = sessionRecord.coldStart
        self.crashReportId = sessionRecord.crashReportId
        self.properties = metadata.reduce(into: [:]) { result, record in
            guard UserResourceKey(rawValue: record.key) == nil else {
                // prevent UserResource keys from appearing in properties
                // will be sent in UserInfoPayload instead
                return
            }
            result[record.key] = record.stringValue
        }
    }
}
