//
//  OrderDetails.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 4/12/24.
//

import Foundation

struct OrderDetails: Codable {
    let OrderDetailID: Int
    let OrderID: Int
    let ProductID: Int
    let ProductDescription: String
    let Quantity: Int
    let Price: Double
}
