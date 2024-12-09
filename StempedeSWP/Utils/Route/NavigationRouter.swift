//
//  NavigationRouter.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 5/12/24.
//

import Foundation
import SwiftUI

final class NavigationRouter: ObservableObject {
    @Published var routes = [Route]()
    func push(to screen: Route) {
        guard !routes.contains(screen) else{
            return
        }
        routes.append(screen)
    }
    func reset(){
        routes = []
    }
    func goBack(){
        _ = routes.popLast()
    }
    func replace(stack: [Route]) {
        routes = stack
    }
}
