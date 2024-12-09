//
//  Orders.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 4/12/24.
//

import Foundation

struct Orders: Codable, Identifiable {
    let OrderID: Int
    let UserID: Int
    let OrderDate: String
    let TotalAmount: Double
    var id: Int { OrderID }
}
