//
//  SubcategoriesService.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 4/12/24.
//

import Foundation

protocol SubcategoriesServiceProtocol {
    func getSubcategories() async throws -> [Subcategories]
}

class SubcategoriesService: SubcategoriesServiceProtocol {
    let httpClient: HTTPClient
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    func getSubcategories() async throws -> [Subcategories] {
        let getSubcategoriesRequest = Request(endpoint: .subcategories)
        let getSubcategoriesResource = Resource(url: getSubcategoriesRequest.url!, modelType: [Subcategories].self)
        let getSubcategoriesResponse = try await httpClient.load(getSubcategoriesResource)
        return getSubcategoriesResponse
    }
}
