//
//  OrdersService.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 4/12/24.
//

import Foundation

struct orderDetailsInCreateOrderBody: Codable {
    let ProductID: Int
    let ProductDescription: String
    let Quantity: Int
    let Price: Double
}

struct CreateOrderBody: Codable {
    let UserID: Int
    let OrderDate: String
    let TotalAmount: Double
    let orderDetails: [orderDetailsInCreateOrderBody]  // Use lowercase `orderDetails`
}

struct CreateOrderResponse: Codable {
    let message: String
    let orderID: Int
}

// MARK: -Main functionalities
protocol OrdersServiceProtocol {
    func createOrder(body: CreateOrderBody) async throws -> CreateOrderResponse
}

class OrdersService: OrdersServiceProtocol {
    let httpClient: HTTPClient
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    @MainActor
    func createOrder(body: CreateOrderBody) async throws -> CreateOrderResponse {
        guard let jsonData = try? JSONEncoder().encode(body) else {
            print("DEBUG: Error in decoding jsonData in Login Body")
            throw NetworkError.errorResponse(ErrorResponse(message: "Error in decoding jsonData in Login Body"))
            }
        let createOrderRequest = Request(endpoint: .orders)
        let createOrderResource = Resource(url: createOrderRequest.url!, method: .post(jsonData), modelType: CreateOrderResponse.self)
        let createOrderResponse = try await httpClient.load(createOrderResource)
        return createOrderResponse
    }
    @MainActor
    func getOrders(userID: String) async throws -> [Orders] {
        let getOrdersRequest = Request(endpoint: .orders, pathComponents: ["user", userID])
        let getOrdersResource = Resource(url: getOrdersRequest.url!, method: .get, modelType: [Orders].self)
        let getOrdersResponse = try await httpClient.load(getOrdersResource)
        return getOrdersResponse
    }
    
}
