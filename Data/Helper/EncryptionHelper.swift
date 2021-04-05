//
//  EncryptionHelper.swift
//  Data
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation
import Domain
import CommonCrypto

internal struct EncryptionHelper {

    internal static func archive(object: Any) -> Data {
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: true)
        } catch {
            return Data()
        }
    }

    internal static func unArchive(data: Data) -> Any? {
        do {
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
        } catch {
            return error
        }
    }

    // The iv is prefixed to the encrypted data
    internal static func aesCBCEncrypt(data: Data, key: String) throws -> Data {
        guard let keyData = key.data(using: .utf8) else {
            throw EncryptionDomainError(type: .keyError)
        }
        let keyLength = keyData.count
        let validKeyLengths = [kCCKeySizeAES128, kCCKeySizeAES192, kCCKeySizeAES256]
        if !validKeyLengths.contains(keyLength) {
            throw EncryptionDomainError(type: .keyError)
        }

        let ivSize = kCCBlockSizeAES128
        let cryptLength = size_t(ivSize + data.count + kCCBlockSizeAES128)
        var cryptData = Data(count: cryptLength)

        let status = cryptData.withUnsafeMutableBytes { ivBytes -> Int32 in
            let ivBytesPointer = UnsafeMutableRawPointer.allocate(byteCount: ivBytes.count, alignment: MemoryLayout<Int32>.alignment)
            return SecRandomCopyBytes(kSecRandomDefault, kCCBlockSizeAES128, ivBytesPointer)
        }
        if status != .zero {
            throw EncryptionDomainError(type: .ivError)
        }

        var numBytesEncrypted: size_t = .zero
        let options   = CCOptions(kCCOptionPKCS7Padding)

        var cryptStatus: CCCryptorStatus!
        do {
            cryptStatus = try cryptData.withUnsafeMutableBytes { cryptBytes in
                try data.withUnsafeBytes { dataBytes in
                    try keyData.withUnsafeBytes { keyBytes -> CCCryptorStatus in

                        guard let keyBytesBaseAddress = keyBytes.baseAddress,
                              let dataBytesBaseAddress = dataBytes.baseAddress,
                              let cryptBytesBaseAddress = cryptBytes.baseAddress else {
                            throw EncryptionDomainError(type: .cryptorError)
                        }

                        return CCCrypt(CCOperation(kCCEncrypt),
                                       CCAlgorithm(kCCAlgorithmAES),
                                       options,
                                       keyBytesBaseAddress, keyLength,
                                       cryptBytesBaseAddress,
                                       dataBytesBaseAddress, data.count,
                                       cryptBytesBaseAddress+kCCBlockSizeAES128, cryptLength,
                                       &numBytesEncrypted)
                    }
                }
            }
        } catch {
            throw EncryptionDomainError(type: .cryptorError)
        }

        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            cryptData.count = numBytesEncrypted + ivSize
        } else {
            throw EncryptionDomainError(type: .cryptorError)
        }

        return cryptData
    }

    // The iv is prefixed to the encrypted data
    internal static func aesCBCDecrypt(data: Data, key: String) throws -> Data {
        guard let keyData = key.data(using: .utf8) else {
            throw EncryptionDomainError(type: .keyError)
        }
        let keyLength = keyData.count
        let validKeyLengths = [kCCKeySizeAES128, kCCKeySizeAES192, kCCKeySizeAES256]
        if !validKeyLengths.contains(keyLength) {
            throw EncryptionDomainError(type: .keyError)
        }

        let ivSize = kCCBlockSizeAES128
        let clearLength = size_t(data.count - ivSize)
        var clearData = Data(count: clearLength)

        var numBytesDecrypted: size_t = .zero
        let options   = CCOptions(kCCOptionPKCS7Padding)

        var cryptStatus: CCCryptorStatus!
        do {
            cryptStatus = try clearData.withUnsafeMutableBytes { cryptBytes in
                try data.withUnsafeBytes { dataBytes in
                    try keyData.withUnsafeBytes { keyBytes -> CCCryptorStatus in

                        guard let keyBytesBaseAddress = keyBytes.baseAddress,
                              let dataBytesBaseAddress = dataBytes.baseAddress,
                              let cryptBytesBaseAddress = cryptBytes.baseAddress else {
                            throw EncryptionDomainError(type: .cryptorError)
                        }

                        return CCCrypt(CCOperation(kCCDecrypt),
                                       CCAlgorithm(kCCAlgorithmAES128),
                                       options,
                                       keyBytesBaseAddress, keyLength,
                                       dataBytesBaseAddress,
                                       dataBytesBaseAddress+kCCBlockSizeAES128, clearLength,
                                       cryptBytesBaseAddress, clearLength,
                                       &numBytesDecrypted)
                    }
                }
            }
        } catch {
            throw EncryptionDomainError(type: .cryptorError)
        }

        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            clearData.count = numBytesDecrypted
        } else {
            throw EncryptionDomainError(type: .cryptorError)
        }

        return clearData
    }

    internal static func md5Hex(_ string: String) -> String {
        return md5(string).map { String(format: "%02hhx", $0) }.joined()
    }

    private static func md5(_ string: String) -> Data {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using: .utf8)!
        var digestData = Data(count: length)

        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return .zero
            }
        }
        return digestData
    }

}
