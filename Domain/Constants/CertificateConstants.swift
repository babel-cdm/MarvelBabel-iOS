//
//  CertificateConstants.swift
//  Domain
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation

public class CertificateConstants {

    public class var prefixCertificate: String {
        return "MARVEL_"
    }

    public static let nameProCertificate = "*.marvel.com"

    public class func getCertificates() -> [String] {
        return [nameProCertificate]
    }

}
