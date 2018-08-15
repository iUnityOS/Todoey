//
//  Task.swift
//  Todoey
//
//  Created by Muhanad Azzeh on 8/7/18.
//  Copyright © 2018 Prema. All rights reserved.
//

import Foundation


class Task : Encodable, Decodable {
    
    var taskTitle : String?
    var taskStatus = false
    
    init(title : String, isDone : Bool) {
        
        taskTitle = title
        taskStatus = isDone
    }
}
