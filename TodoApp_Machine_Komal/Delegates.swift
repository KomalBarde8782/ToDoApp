//
//  Delegates.swift
//  TodoApp_Machine_Komal
//
//  Created by Mac on 16/02/20.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation

//reload data
protocol ReloadDataProtocol {
    func reloadData()
}

//Update
protocol UpdateDataProtocol {
    func updateData(taskUpdated : String)
}
