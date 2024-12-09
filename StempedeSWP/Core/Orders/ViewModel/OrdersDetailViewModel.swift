//
//  OrdersDetailViewModel.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 7/12/24.
//

import Foundation

class OrdersDetailViewModel: ObservableObject {
    @Published private(set) var loadingState: LoadingState = .finished
    @Published var error: NetworkError?
    @Published private(set) var ordersDetailResponse = [getOrdersDetailResponse]()
    let ordersDetailService: OrderDetailsService
    let OrderID: String
    init(ordersDetailService: OrderDetailsService, OrderID: String){
        self.ordersDetailService = ordersDetailService
        self.OrderID = OrderID
        loadData()
    }
    
    @MainActor
    func loadOrdersDetail() async throws {
        defer { loadingState = .finished }
        do{
            loadingState = .loading
            let ordersDetailResponse = try await ordersDetailService.getOrderDetails(orderID: OrderID)
            self.ordersDetailResponse = ordersDetailResponse
        }catch let error as NetworkError {
            self.error = error
            print("Error: \(error)")
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func loadData(){
        Task(priority: .medium){
            try await loadOrdersDetail()
        }
    }
    
    @MainActor
    func handleRefresh(){
        ordersDetailResponse.removeAll()
        loadData()
    }
}
