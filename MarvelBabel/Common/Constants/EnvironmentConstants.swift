//
//  EnvironmentConstants.swift
//  Data
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation
import Domain

internal struct EnvironmentConstants {
    #if MOCK
    internal static let protocolHost = ""
    internal static let restHost = ""
    internal static let marvelPVKey = ""
    internal static let marvelPBKey = ""
    #else
    internal static let protocolHost = DomainConstants.ProtocolHost.https
    internal static let restHost = "gateway.marvel.com"
    internal static let marvelPVKey = "0ed42722f083f074f95e8f9cb1ea9607c5781946"
    internal static let marvelPBKey = "ba9dbe77040fd5833bcd484fa79a0452"
    #endif
}
