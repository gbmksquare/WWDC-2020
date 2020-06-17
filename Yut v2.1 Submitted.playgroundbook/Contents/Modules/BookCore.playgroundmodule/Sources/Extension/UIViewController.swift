//
//  UIViewController.swift
//  BookCore
//
//  Created by BumMo Koo on 2020/05/18.
//

import UIKit
import PlaygroundSupport

extension UIViewController: PlaygroundLiveViewMessageHandler, PlaygroundLiveViewSafeAreaContainer {
    public static func liveView() -> PlaygroundLiveViewable {
        return Self.instantiateFromStoryboard()
    }
}

public extension UIViewController {
    static func instantiateFromStoryboard() -> UIViewController {
        let identifier = String(describing: self)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(identifier: identifier)
    }
}
