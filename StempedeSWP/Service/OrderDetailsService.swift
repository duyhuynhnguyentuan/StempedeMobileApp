//
//  OrderDetailsService.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 4/12/24.
//

import Foundation

import Foundation

struct getOrdersDetailResponse:  Codable, Identifiable {
    var id: Int { OrderDetailID }
    let OrderDetailID: Int
    let OrderID: Int
    let ProductID: Int
    let OrderProductDescription: String
    let Quantity: Int
    let OrderPrice: Int
    let ProductName: String
    let ProductDescription: String
    let ImagePath: String
    let ProductPrice: Int
    let StockQuantity: Int
    let Ages: String
    let SupportInstances: Int
    let LabID: Int
    let SubcategoryID: Int
    let LabName: String
    let LabDescription: String
    let LabFileURL: String
    let VideoURL: String?
}

protocol OrderDetailsServiceProtocol {
    func getOrderDetails(orderID: String) async throws -> [getOrdersDetailResponse]
}

class OrderDetailsService: OrderDetailsServiceProtocol {
    let httpClient: HTTPClient
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    @MainActor
    func getOrderDetails(orderID: String) async throws -> [getOrdersDetailResponse] {
        let getOrderDetailsRequest = Request(endpoint: .orderdetails, pathComponents: ["by-order", orderID])
        let getOrderDetailsResource = Resource(url: getOrderDetailsRequest.url!, modelType: [getOrdersDetailResponse].self)
        let getOrderDetailsResponse = try await httpClient.load(getOrderDetailsResource)
        return getOrderDetailsResponse
    }
    
    
}
