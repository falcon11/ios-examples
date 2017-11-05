//
//  PresentedVCDelegate.swift
//  Examples
//
//  Created by Ashoka on 05/11/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

public protocol PresentedVCDelegate: NSObjectProtocol {
    func didPresented(vc: UIViewController)
}
