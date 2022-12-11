//
//  DummyBackgroundImages.swift
//  Suny
//
//  Created by Samreth Kem on 12/9/22.
//

import UIKit

struct Constants {
    static let bottomImgStrings = [
        "suny-bg-1",
        "suny-bg-2",
        "suny-bg-3",
        "suny-bg-4",
        "suny-bg-5",
        "suny-bg-6",
        "suny-bg-7",
        "suny-bg-8",
        "suny-bg-9",
        "suny-bg-10",
    ]
    
    static var screenFrame: CGRect {
        get {
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
                return CGRect()
            }
            return window.frame
        }
    }
    
    static var screenWidth: CGFloat {
        get {
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
                return CGFloat()
            }
            return window.frame.width
        }
    }
    
    static var screenHeight: CGFloat {
        get {
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
                return CGFloat()
            }
            return window.frame.height
        }
    }
}
