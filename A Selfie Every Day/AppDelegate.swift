//
//  AppDelegate.swift
//  A Selfie Every Day
//
//  Created by canella riccardo on 08/11/21.
//

import Foundation
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
        
    static var orientationLock = UIInterfaceOrientationMask.landscapeRight

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
