//
//  Subcategories.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 4/12/24.
//

import Foundation

struct Subcategories:  Identifiable, Encodable, Decodable, Hashable {
    let SubcategoryID: Int
    let SubcategoryName: String
    let Description: String?
    var id: Int { SubcategoryID }
}

extension Subcategories {
    static var sample = Subcategories(SubcategoryID: 1,
                                       SubcategoryName: "Robotics",
                                       Description: nil)
}
