//
//  Endpoint.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 2/12/24.
//

import Foundation

enum Endpoint: String, CaseIterable, Hashable {
    ///endpoint for labs
    case labs
    ///endpoint for orderDetail
    case orderdetails
    ///endpoint for orders
    case orders
    ///endpoint for product
    case products
    ///endpoint for subcategories
    case subcategories
    ///endpoint fot auth
    case auth
}
