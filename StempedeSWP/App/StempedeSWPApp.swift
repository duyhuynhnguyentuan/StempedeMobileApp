//
//  StempedeSWPApp.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 2/12/24.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    var app: StempedeSWPApp?
}
@main
struct StempedeSWPApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @StateObject private var routerManager = NavigationRouter()
    @StateObject private var cartManager = ShoppingCartManager()
    var body: some Scene {
        WindowGroup {
            ContentView(authService: AuthService(keychainService: KeychainService.shared, httpClient: HTTPClient()))
                .environmentObject(routerManager)
                .environmentObject(cartManager)
                .onAppear{
                    appDelegate.app = self
                }
                .onOpenURL { url in
                    Task{
                        print(url)
                        await handleDeeplinking(from: url)
                    }
                }
        }
    }
}
private extension StempedeSWPApp {
    //hnadle deeplink
    func handleDeeplinking(from url: URL) async {
        let routeFinder = RouteFinder()
        if let route = await routeFinder.find(from: url) {
            routerManager.push(to: route)
        }
    }
}
