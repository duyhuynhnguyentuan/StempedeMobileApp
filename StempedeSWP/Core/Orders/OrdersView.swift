//
//  OrdersView.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 5/12/24.
//

import SwiftUI

struct OrdersView: View {
    @StateObject var viewModel: OrdersViewModel
    @EnvironmentObject private var routerManager : NavigationRouter

    init(){
        _viewModel = StateObject(wrappedValue: OrdersViewModel(ordersService: OrdersService(httpClient: HTTPClient()), biometricService: BiometricService()))
    }
    var body: some View {
        NavigationStack(path: $routerManager.routes){
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if viewModel.orders.isEmpty {
                        Text("Chưa có đơn hàng nào")
                            .font(.headline.bold())
                    }
                    if viewModel.loadingState == .loading {
                        OrdersViewRowPlaceHolder()
                    } else {
                        ForEach(viewModel.orders) { order in
                            NavigationLink(value: Route.ordersDetail(OrderID: String( order.OrderID))){
                                OrdersViewRow(order: order)
                            }
                        }
                    }
                }
                .padding()
            }
            .refreshable {
                viewModel.handleRefresh()
            }
            .navigationTitle("Orders")
            .navigationDestination(for: Route.self) { $0 }
            .onAppear {
                do {
                    viewModel.biometricError = nil
                    try viewModel.authenticateWithBiometrics()
                } catch {
                    print("Biometric authentication failed with error: \(error.localizedDescription)")
                }
            }
            .alert(item: $viewModel.biometricError) { errorMessage in
                Alert(
                    title: Text("Biometric Authentication Failed"),
                    message: Text(errorMessage.errorDescription ?? "An unknown error occurred."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

#Preview {
    OrdersView()
}
