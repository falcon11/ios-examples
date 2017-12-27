//
//  Logger.swift
//  outing
//
//  Created by Ashoka on 15/12/2017.
//  Copyright © 2017 ashoka. All rights reserved.
//

import UIKit
import SwiftyBeaver

let log = SwiftyBeaver.self

func setupLogger() -> Void {
    let console = ConsoleDestination()
    
    #if DEBUG
        console.minLevel = .verbose
    #else
        console.minLevel = .error
        let file = FileDestination()
        file.minLevel = .error
        log.addDestination(file)
    #endif
    log.addDestination(console)
}
