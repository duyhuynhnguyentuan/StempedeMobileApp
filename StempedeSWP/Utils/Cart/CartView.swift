//
//  CartView.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 6/12/24.
//

import SwiftUI
import StripePaymentSheet

struct CartView: View {
    @EnvironmentObject private var routerManager: NavigationRouter
    @EnvironmentObject private var cartManager: ShoppingCartManager
    @StateObject var viewModel: CartViewModel
    @State private var showAlert = false
    @State private var successMessage: String = ""
    let Email: String
    let UserID: String

    init() {
        _viewModel = StateObject(wrappedValue: CartViewModel(ordersService: OrdersService(httpClient: HTTPClient())))
        self.Email = KeychainService.shared.retrieveToken(forKey: "Email") ?? ""
        self.UserID = KeychainService.shared.retrieveToken(forKey: "UserID") ?? ""
    }

    var body: some View {
        List {
            // Get grouped items from the cart manager
            let items = cartManager.getGroupedCart()
            
            // Iterate over the items in the cart
            ForEach(Array(items.keys).sorted(by: { $0.ProductName < $1.ProductName }), id: \.self) { cartItem in
                // Get the count of each item
                let count = items[cartItem]!
                
                // Display cart item details
                LabeledContent {
                    let price = cartItem.Price * Double(count)
                    HStack {
                        Text(price, format: .currency(code: Locale.current.currency?.identifier ?? ""))
                        Spacer()
                        Text("x\(count)").font(.callout).bold()
                    }
                } label: {
                    AsyncImage(url: URL(string: cartItem.ImagePath)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(15)
                    } placeholder: {
                        Color(.secondarySystemBackground)
                            .cornerRadius(15)
                    }
                    Text("\(cartItem.ProductName)")
                    Text("Mô tả: \(cartItem.Description)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .swipeActions {
                    Button(role: .destructive) {
                        cartManager.remove(id: cartItem.id)
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(.red)
                }
            }

            Section {
                LabeledContent {
                    Text(cartManager.getTotal(), format: .currency(code: Locale.current.currency?.identifier ?? ""))
                        .bold()
                        .foregroundStyle(.red)
                } label: {
                    Text("Tổng tiền")
                }
            }
            
            // MARK: Thanh toan
            Button {
                viewModel.preparePaymentSheet(email: Email, amount: cartManager.getTotal())
            } label: {
                if let paymentSheet = viewModel.paymentSheet {
                    PaymentSheet.PaymentButton(
                        paymentSheet: paymentSheet,
                        onCompletion: viewModel.onPaymentCompletion
                    ) {
                        Text("Thanh toán ngay!")
                            .font(.title3.bold())
                            .modifier(ButtonModifier())
                    }
                } else {
                    Text("Yêu cầu thanh toán")
                        .font(.title3.bold())
                        .modifier(ButtonModifier(backgroundColor: .gray))
                }
            }

            if let result = viewModel.paymentResult {
                switch result {
                case .completed:
                    // Set the success message and show the alert
                    Text("Thanh toán thành công")
                        .font(.callout.bold())
                        .foregroundStyle(.green)
                        .onAppear {
                            successMessage = "Thanh toán thành công. Cảm ơn bạn đã mua sắm!"
                            showAlert = true // Show the alert
                        }
                case .failed(let error):
                    Text("Thanh toán thất bại: \(error.localizedDescription)")
                        .font(.callout.bold())
                        .foregroundStyle(.red)
                case .canceled:
                    Text("Đã hủy thanh toán.")
                        .font(.callout.bold())
                        .foregroundStyle(.yellow)
                }
            }

            // Display the error as text if there is an error
            if let error = viewModel.error {
                Text("Lỗi: \(error.localizedDescription)")
                    .foregroundColor(.red)
                    .font(.callout.bold())
                    .padding()
            }
        }
        .disabled(viewModel.loadingState == .loading) // Disable interactions during loading
        .overlay(
            Group {
                if viewModel.loadingState == .loading {
                    Color.black.opacity(0.7) // Dimming overlay
                        .edgesIgnoringSafeArea(.all)
                    ProgressView()
                }
            }
        )
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(successMessage),
                dismissButton: .default(Text("OK")) {
                    // Handle dismissal and reset
                    viewModel.paymentResult = nil
                    routerManager.reset()
                    routerManager.push(to: .orders)
                    cartManager.removeAll()
                }
            )
        }
        .navigationTitle("Giỏ hàng")
    }
}

#Preview {
    CartView()
}


