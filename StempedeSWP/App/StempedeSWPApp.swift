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
//[
//  {
//    "OrderDetailID": 44,
//    "OrderID": 31,
//    "ProductID": 36,
//    "OrderProductDescription": "A fun and interactive robot that teaches coding through play.",
//    "Quantity": 1,
//    "OrderPrice": 341000,
//    "ProductName": "Wonder Workshop Dash Robot",
//    "ProductDescription": "A fun and interactive robot that teaches coding through play.",
//    "ImagePath": "https://m.media-amazon.com/images/I/61itaelCGcL.jpg",
//    "ProductPrice": 341000,
//    "StockQuantity": 59,
//    "Ages": "8+        ",
//    "SupportInstances": 5,
//    "LabID": 3,
//    "SubcategoryID": 2,
//    "LabName": "Snap Circuits Jr. Lab",
//    "LabDescription": "Learn about electronic circuits using Snap Circuits Jr.",
//    "LabFileURL": "https://www.learningcontainer.com/wp-content/uploads/2019/09/sample-pdf-download-10-mb.pdf",
//    "VideoURL": "https://www.youtube.com/watch?v=NwWNny_ocR4&list=PLnRl-W3gZI79kfp8E7lcDkImtMHA6FIfr&index=2"
//  }
//]
