//
//  FeedViewModel.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 5/12/24.
//

import Foundation

class FeedViewModel: ObservableObject {
    @Published var error: NetworkError?
    @Published private(set) var loadingState: LoadingState = .finished
    @Published private(set) var products = [Products]()
    @Published private(set) var subcategories = [Subcategories]()
    @Published var selectedSubcategories = Set<Int>() // Track selected subcategories for filtering
    
    let productsService: ProductsService
    let subcategoriesService: SubcategoriesService
    @Published var searchText: String = ""
    init(productsService: ProductsService, subcategoriesService: SubcategoriesService){
        self.productsService = productsService
        self.subcategoriesService = subcategoriesService
        loadData()
    }
    
    var filteredProducts: [Products] {
        var products = self.products
        
        // Filter by search text
        if searchText.count > 0 {
            products = products.filter { $0.ProductName.localizedCaseInsensitiveContains(searchText) }
        }
        
        // Filter by selected subcategories
        if !selectedSubcategories.isEmpty {
            products = products.filter { selectedSubcategories.contains($0.SubcategoryID) }
        }
        
        return products
    }

    @MainActor
    func loadProducts() async throws {
        defer { loadingState = .finished }
        do{
            loadingState = .loading
            let products = try await productsService.getProducts()
            self.products = products
        }catch let error as NetworkError {
            self.error = error
            print("Error: \(error)")
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func loadSubcategories() async throws {
        defer { loadingState = .finished }
        do{
            loadingState  = .loading
            let subcategories = try await subcategoriesService.getSubcategories()
            self.subcategories = subcategories
        }catch let error as NetworkError {
            self.error = error
            print("Error: \(error)")
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
    func loadData(){
        Task(priority: .high){
            try await loadProducts()
            try await loadSubcategories()
        }
    }
    @MainActor
    func handleRefresh() {
        products.removeAll()
        loadData()
    }

}
