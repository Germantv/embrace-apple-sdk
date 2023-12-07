//
//  Copyright © 2023 Embrace Mobile, Inc. All rights reserved.
//

import Foundation
import Security
import EmbraceCommon

class KeychainAccess {

    static let kEmbraceKeychainService = "io.embrace.keys"
    static let kEmbraceDeviceId = "io.embrace.deviceid_v3"

    private init() { }

    static var keychain: KeychainInterface = DefaultKeychainInterface()

    static var deviceId: UUID {
        // fetch existing id
        let pair = keychain.valueFor(
            service: kEmbraceKeychainService as CFString,
            account: kEmbraceDeviceId as CFString
        )

        if let _deviceId = pair.value {
            if let uuid = UUID(uuidString: _deviceId) {
                return uuid
            }
            ConsoleLog.error("Failed to construct device id from keychain")
        }

        // generate new id
        let newId = UUID()
        let status = keychain.setValue(
            service: kEmbraceKeychainService as CFString,
            account: kEmbraceDeviceId as CFString,
            value: newId.uuidString
        )

        if status != errSecSuccess {
            if let err = SecCopyErrorMessageString(status, nil) {
                ConsoleLog.error("Write failed: \(err)")
            }
        }

        return newId
    }
}
