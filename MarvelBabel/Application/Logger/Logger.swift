//
//  Logger.swift
//  MarvelBabel
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import UIKit

public class Logger {

    public enum PrintMode: String {
        case basic
        case full
    }

    public static func print(_ items: Any..., separator: String = " ", terminator: String = "\n", mode: PrintMode = .basic) {
        #if DEBUG
        if mode == .basic {
            Swift.print(items.first ?? "")
        } else {
            Swift.print(items, separator: separator, terminator: terminator)
        }
        #endif
    }

}
