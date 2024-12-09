//
//  Products.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 4/12/24.
//

import Foundation

struct Products: Identifiable, Encodable, Decodable, Hashable {
    let ProductID: Int
    let ProductName: String
    let Description: String
    let ImagePath: String
    let Price: Double
    let StockQuantity: Int
    let Ages: String
    let SupportInstances: Int
    let LabID: Int
    let SubcategoryID: Int
    var id: Int { ProductID }
}

import SwiftUI

extension Products {
    var status: String {
        return StockQuantity <= 0 ? "Hết hàng" : "Còn hàng"
    }
    
    var statusColor: Color {
        return StockQuantity <= 0 ? .red : .green
    }
}

extension Products {
    static var sample = Products(ProductID: 1,
                                 ProductName: "LEGO Education WeDo 2.0",
                                 Description: "A hands-on learning kit that teaches students to build and program robots using LEGO bricks.",
                                 ImagePath: "https://vn-test-11.slatic.net/p/a9a862c0318404f1ae970da2e6c3b9b8.png",
                                 Price: 200000,
                                 StockQuantity: 11,
                                 Ages: "7+        ",
                                 SupportInstances: 5,
                                 LabID: 1,
                                 SubcategoryID: 2)
}
