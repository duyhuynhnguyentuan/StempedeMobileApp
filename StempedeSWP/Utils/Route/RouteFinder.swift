//
//  RouteFinder.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 5/12/24.
//

import Foundation

enum DeepLinkUrls: String {
    case products
}

struct RouteFinder {
    func find(from url: URL) async -> Route? {
        guard let host = url.host() else { return nil }
        switch DeepLinkUrls(rawValue: host) {
        case .products:
            let queryParams = url.queryParameters
            guard let ProductIDQueryVal = queryParams?["ProductID"] as? String else
            {
                return nil
            }
            return .products(ProductID: ProductIDQueryVal)
        default:
            return nil
            
        }
    }
}
extension URL {
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()){ (result, item) in
            result[item.name] = item.value?.replacingOccurrences(of: "+", with: " ")
        }
        
    }
}
