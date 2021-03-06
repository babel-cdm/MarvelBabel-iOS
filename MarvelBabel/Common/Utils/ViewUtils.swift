//
//  ViewUtils.swift
//  MarvelBabel
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import UIKit

public struct ViewUtils {

    /**
     Get an array of constraints, matching all sides of the child view, with the parent view.

     - Parameters:
     - item: Child view you want to add on the view.
     - toItem: Parent view where you want the view to be added.
     */
    public static func getContainerConstraints(item: NSObject, toItem: NSObject) -> [NSLayoutConstraint] {
        let topConstraint = NSLayoutConstraint(item: item, attribute: .top, relatedBy: .equal,
                                               toItem: toItem, attribute: .top,
                                               multiplier: 1, constant: .zero)
        let bottomConstraint = NSLayoutConstraint(item: item, attribute: .bottom, relatedBy: .equal,
                                                  toItem: toItem, attribute: .bottom,
                                                  multiplier: 1, constant: .zero)
        let leadingConstraint = NSLayoutConstraint(item: item, attribute: .leading, relatedBy: .equal,
                                                   toItem: toItem, attribute: .leading,
                                                   multiplier: 1, constant: .zero)
        let trailingConstraint = NSLayoutConstraint(item: item, attribute: .trailing, relatedBy: .equal,
                                                    toItem: toItem, attribute: .trailing,
                                                    multiplier: 1, constant: .zero)

        return [topConstraint, bottomConstraint, leadingConstraint, trailingConstraint]
    }

    /**
     Get an array of constraints, centering the view in other view (center x and y).

     - Parameters:
     - item: Child view you want to center on the view.
     - toItem: Parent view where you want the view to be centered.
     */
    public static func getCenterConstraints(item: NSObject, toItem: NSObject) -> [NSLayoutConstraint] {
        let centerHorConstraint = NSLayoutConstraint(item: item, attribute: .centerX, relatedBy: .equal,
                                                     toItem: toItem, attribute: .centerX,
                                                     multiplier: 1, constant: .zero)
        let centerVerConstraint = NSLayoutConstraint(item: item, attribute: .centerY, relatedBy: .equal,
                                                     toItem: toItem, attribute: .centerY,
                                                     multiplier: 1, constant: .zero)

        return [centerHorConstraint, centerVerConstraint]
    }

}
