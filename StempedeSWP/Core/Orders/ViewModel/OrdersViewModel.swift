//
//  OrdersViewModel.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 7/12/24.
//

import Foundation
enum BiometricError: Error, LocalizedError, Identifiable {
    var id: UUID { UUID() }

    case deniedAccess
    case noFaceIDEnrolled
    case noFingerprintEnrolled
    case noOpticIdEnrolled
    case biometricError

    var errorDescription: String? {
        switch self {
        case .deniedAccess:
            return "Access denied to biometric authentication. Please allow it in Settings."
        case .noFaceIDEnrolled:
            return "No FaceID enrolled. Please set up FaceID."
        case .noFingerprintEnrolled:
            return "No fingerprints enrolled. Please set up TouchID."
        case .noOpticIdEnrolled:
            return "No OpticID enrolled. Please set up OpticID."
        case .biometricError:
            return "Biometric authentication failed. Please try again."
        }
    }
}

class OrdersViewModel: ObservableObject {
    @Published private(set) var loadingState: LoadingState = .finished
    @Published var error: NetworkError?
    @Published var biometricError: BiometricError?
    @Published private(set) var orders = [Orders]()
    let biometricService: BiometricService
    let ordersService: OrdersService
    let UserID: String
    init(ordersService: OrdersService, biometricService: BiometricService) {
        self.ordersService = ordersService
        self.biometricService = biometricService
        self.UserID = KeychainService.shared.retrieveToken(forKey: "UserID") ?? ""
        loadData()
    }
    
    @MainActor
    func loadOrder() async throws{
        defer { loadingState = .finished }
        do {
            loadingState = .loading
            let orders = try await ordersService.getOrders(userID: UserID)
            self.orders = orders
        } catch let error as NetworkError {
            self.error = error
            print("Error: \(error)")
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
    func authenticateWithBiometrics() throws {
        loadingState = .loading
        biometricService.requestBiometricUnlock { [weak self] result in
            switch result {
            case .success:
                self!.loadingState = .finished
               
                // Use credentials as needed
            case .failure(let error):
                print("Biometric authentication failed: \(error.localizedDescription)")
                self?.biometricError = error
               
            }
        }
    }
    func loadData(){
        Task(priority: .medium){
            try await loadOrder()
        }
    }
    
    @MainActor
    func handleRefresh(){
        orders.removeAll()
        loadData()
    }
}
