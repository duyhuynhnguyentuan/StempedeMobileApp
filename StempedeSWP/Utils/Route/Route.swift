//
//  Route.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 5/12/24.
//

import Foundation
import SwiftUI

enum Route {
    case products(ProductID: String)
    case orders
    case cart
    case ordersDetail(OrderID: String)
}

extension Route {
    static func buildDeepLink(from route: Route) -> URL? {
        switch route {
        case .products(let ProductID):
            var url = URL(string: "stempede://products")!
            let queryItems = [URLQueryItem(name: "ProductID", value: ProductID)]
            url.append(queryItems: queryItems)
            return url
        default:
            break
        }
    return nil
    }
}

extension Route: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.hashValue)
    }
    static func == (lhs: Route, rhs: Route) -> Bool {
        switch (lhs, rhs){
        case (.products(let lhsItem), .products(let rhsItem)):
            return lhsItem == rhsItem
        case (.orders, .orders):
            return true
        case (.cart, .cart):
            return true
        case (.ordersDetail(let lhsItem), .ordersDetail(let rhsItem)):
            return lhsItem == rhsItem
        default:
            return false
        }
    }
}
extension Route: View {
    var body: some View {
        switch self {
        case .products(let ProductID):
            FeedDetailView(ProductID: ProductID)
                .toolbarVisibility(.hidden, for: .tabBar)
        case .orders:
            OrdersView()
                .navigationBarBackButtonHidden()
        case .cart:
            CartView()
        case .ordersDetail(let OrderID):
            OrdersDetailView(OrderID: OrderID)
        }
    }
}

