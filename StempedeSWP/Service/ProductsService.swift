//
//  ProductsService.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 4/12/24.
//

import Foundation

protocol ProductsServiceProtocol {
    func getProducts() async throws -> [Products]
}

class ProductsService: ProductsServiceProtocol {
    let httpClient: HTTPClient
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    @MainActor
    func getProducts() async throws -> [Products] {
        let getProductsRequest = Request(endpoint: .products)
        let getProductsResource = Resource(url: getProductsRequest.url!, modelType: [Products].self)
        let getProductsResponse = try await httpClient.load(getProductsResource)
        return getProductsResponse
    }
    func getProduct(ProductID: String) async throws -> Products {
        let getProductRequest = Request(endpoint: .products, pathComponents: [ProductID])
        let getProductResource = Resource(url: getProductRequest.url!, modelType: Products.self)
        let getProductResponse = try await httpClient.load(getProductResource)
        return getProductResponse
    }
    
    
}
