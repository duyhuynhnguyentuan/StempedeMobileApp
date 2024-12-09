//
//  ShoppingCartManager.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 5/12/24.
//

import Foundation

struct CartItem: Identifiable, Hashable, Encodable, Decodable {
    let id: Int
    let ProductName: String
    let ImagePath: String
    let Price: Double
    let Description: String
    init(product: Products){
        self.id = product.ProductID
        self.ProductName = product.ProductName
        self.ImagePath = product.ImagePath
        self.Price = product.Price
        self.Description = product.Description
    }
}
final class ShoppingCartManager: ObservableObject {
    @Published private(set) var items: [CartItem] = []
    private let cartItemsKey = "cartItems"
    private let promoKey = "promo"
     
    init() {
         loadData()
     }
    func add(product: Products){
        items.append(CartItem(product: product))
        saveData()
    }
    func remove(id: Int){
        items.removeAll(where: { $0.id == id })
        saveData()
    }
    func removeAll(){
        items.removeAll()
        saveData()
    }
    /// this function to get the number of each item
    /// - Returns: list of cart item and their quantity
    func getGroupedCart() -> [CartItem: Int] {
        var itemCounts = [CartItem: Int]()
        for item in items {
            itemCounts[item, default: 0] += 1
        }
        return itemCounts
    }
    
    func getTotal() -> Double {
        let total = items.reduce(0) { $0 + $1.Price }
           return total
    }
    
    private func saveData() {
        // Encode cart items to Data
        if let encodedItems = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encodedItems, forKey: cartItemsKey)
        }
    }

    private func loadData() {
        // Load cart items from UserDefaults
        if let savedItems = UserDefaults.standard.data(forKey: cartItemsKey),
           let decodedItems = try? JSONDecoder().decode([CartItem].self, from: savedItems) {
            items = decodedItems
        }
    }
}
