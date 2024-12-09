//
//  CartViewModel.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 6/12/24.
//

import Foundation
import StripePaymentSheet
class CartViewModel: ObservableObject {
    @Published var paymentSheet: PaymentSheet?
    @Published var paymentResult: PaymentSheetResult?
    @Published var error: NetworkError?
    @Published private(set) var loadingState: LoadingState = .finished
    private var backendCheckoutUrl: URL {
        return URL(string: "https://stempedeapi.onrender.com/api/v1/payment")!
    }
    let ordersService: OrdersService
    init(ordersService: OrdersService){
        self.ordersService = ordersService
    }
    //MARK: -Create order
    @MainActor
    func createOrder(body: CreateOrderBody) async throws -> CreateOrderResponse {
        defer { loadingState = .finished }
        do{
            loadingState = .loading
            let response = try await ordersService.createOrder(body: body)
            return response
        }catch let error as NetworkError {
            self.error = error
            print("Error: \(error)")
            throw error
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
            throw error
        }
    }
    // Inside CartViewModel
    @MainActor
    func prepareAndCreateOrder(userID: String, cartManager: ShoppingCartManager) async throws -> CreateOrderResponse {
        defer { loadingState = .finished }
        
        // Prepare order details from cart
        let items = cartManager.getGroupedCart()
        let totalAmount = cartManager.getTotal()
        
        let orderDetails = items.map { (cartItem, count) in
            orderDetailsInCreateOrderBody(
                ProductID: cartItem.id,
                ProductDescription: cartItem.Description,
                Quantity: count,  // Use the count directly from the tuple
                Price: cartItem.Price
            )
        }

        // Create the order body
        let orderBody = CreateOrderBody(
            UserID: Int(userID) ?? 1,
            OrderDate: DateFormatter.iso8601WithMillisecondsFormatter.string(from: Date()),
            TotalAmount: totalAmount,
            orderDetails: orderDetails
        )

        // Call create order API
        do {
            print(Date().ISO8601Format())
            loadingState = .loading
            let response = try await createOrder(body: orderBody)  // Call the existing createOrder function
            return response
        } catch let error as NetworkError {
            self.error = error
            print("Error: \(error)")
            throw error
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
            throw error
        }
    }


    //MARK: -Stripes
    func onPaymentCompletion(result: PaymentSheetResult) {
      self.paymentResult = result
    }
    func preparePaymentSheet(email: String, amount: Double) {
        // MARK: Fetch the PaymentIntent and Customer information from the backend
        var request = URLRequest(url: backendCheckoutUrl)
        request.httpMethod = "POST"
        
        // Prepare the JSON body with dynamic "email" and "amount" fields
        let parameters: [String: Any] = [
            "email": email, // Use the provided email
            "amount": amount // Use the provided amount
        ]
        
        // Convert parameters dictionary to JSON data
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error serializing JSON: \(error)")
            return
        }

        // Set the headers (if needed)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Make the request
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                  let customer = json["customer"] as? String,
                  let customerEphemeralKeySecret = json["ephemeralKey"] as? String,
                  let paymentIntentClientSecret = json["paymentIntent"] as? String,
                  let publishableKey = json["publishableKey"] as? String,
                  let self = self else {
                return
            }

            STPAPIClient.shared.publishableKey = publishableKey
            // MARK: Create a PaymentSheet instance
            var configuration = PaymentSheet.Configuration()
            configuration.returnURL = "stempede://stripe-redirect"
            configuration.merchantDisplayName = "Stempede"
            configuration.customer = .init(id: customer, ephemeralKeySecret: customerEphemeralKeySecret)
            // Set `allowsDelayedPaymentMethods` to true if your business handles
            // delayed notification payment methods like US bank accounts.
            configuration.allowsDelayedPaymentMethods = true

            DispatchQueue.main.async {
                self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)
            }
        })
        task.resume()
    }

}
