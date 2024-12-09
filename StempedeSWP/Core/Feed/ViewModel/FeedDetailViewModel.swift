//
//  FeedDetailViewModel.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 6/12/24.
//

import Foundation

class FeedDetailViewModel: ObservableObject {
    let ProductID: String
    let productsService: ProductsService
    let labsService: LabsService
    @Published private(set) var loadingState: LoadingState = .finished
    @Published var error: NetworkError?
    @Published private(set) var labs: Labs?
    @Published private(set) var product: Products?
    init(productID: String, productService: ProductsService, labsService: LabsService){
        self.ProductID = productID
        self.productsService = productService
        self.labsService = labsService
        loadData()
    }
    var isOutOfStock: Bool {
        product?.StockQuantity ?? 0 <= 0 ? true : false
    }
    @MainActor
    func loadProduct(ProductID: String) async throws{
        defer { loadingState = .finished }
        do{
            loadingState = .loading
            let product = try await productsService.getProduct(ProductID: ProductID)
            self.product = product
            let labs = try await labsService.getLab(labID: String(product.LabID))
            self.labs = labs
        } catch let error as NetworkError {
            self.error = error
            print("Error: \(error)")
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }

    }
    
    @MainActor
    func loadLab(LabID: String) async throws {
        defer { loadingState = .finished }
        do{
            loadingState = .loading
            let labs = try await labsService.getLab(labID: LabID)
            self.labs = labs
        } catch let error as NetworkError {
            self.error = error
            print("Error: \(error)")
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func loadData(){
        Task{
            try await loadProduct(ProductID: ProductID)
        }
    }
}
