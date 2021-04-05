//
//  RepositoryConstants.swift
//  Domain
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation

public struct RepositoryConstants {

    public struct UserDefaults {
        public static let keyAESUserDefaults = "a19y$B&E)H@rbQeTTWmZ_4t7w!z%C*F-"

        public struct Key {
            public static let appVersion = "appVersion"
        }
    }

    public struct Http {

        public struct Endpoint {
            public static let characters = "/v1/public/characters"
            public static let characterDetail = "/v1/public/characters/%@"
        }

    }

}
