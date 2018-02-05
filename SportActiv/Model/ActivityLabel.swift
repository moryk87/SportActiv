//
//  ActivityLabel.swift
//  SportActiv
//
//  Created by Jan Moravek on 05/02/2018.
//  Copyright © 2018 Jan Moravek. All rights reserved.
//

import Foundation

class ActivityLabel {
    var name: String?
    var location: String?
    var length: Float = 0.0
    
        init(name: String, location: String, length: Float) {
            self.name = name
            self.location = location
            self.length = length
        }
}
