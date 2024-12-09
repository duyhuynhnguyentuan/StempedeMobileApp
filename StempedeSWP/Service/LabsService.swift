//
//  LabsService.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 4/12/24.
//

import Foundation

protocol LabsServiceProtocol {
    func getLab(labID: String) async throws -> Labs
}

class LabsService: LabsServiceProtocol {
    let httpClient: HTTPClient
    init(httpClient: HTTPClient){
        self.httpClient = httpClient
    }
    @MainActor
    func getLab(labID: String) async throws -> Labs {
        let getLabRequest = Request(endpoint: .labs, pathComponents: [labID])
        let getLabResource = Resource(url: getLabRequest.url!, modelType: Labs.self)
        let getLabResponse = try await httpClient.load(getLabResource)
        return getLabResponse
    }
    
    
}
