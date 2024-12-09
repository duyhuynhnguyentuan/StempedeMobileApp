//
//  ContentViewModel.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 3/12/24.
//

import Foundation
import SwiftUI
import Combine
class ContentViewModel: ObservableObject {
    @Published var error: NetworkError?
    @Published private(set) var user: UserResponse?
    ///current state to push to authentication screens or not
    @Published private(set) var isAuthenticated: Bool = false
    let authService: AuthService
    private var cancellables = Set<AnyCancellable>()

    
    //  MARK: - Initializer
    init(authService: AuthService){
        self.authService = authService
        setUpSubscribers()
    }
    // MARK: - Subcribers
    /// to observe changes
    private func setUpSubscribers(){
        // The fk $ in authService.$isAuthenticated is a property wrapper that accesses the Published property in Combine. Ko có dấu $ thì ko xài .sink hay mấy cái modifier
        authService.$isAuthenticated.sink { [weak self] isAuthenticated in
            self?.isAuthenticated = isAuthenticated
        }.store(in: &cancellables)
    }
    
    @MainActor
    func loadUser(UserID: String) async throws {
        do {
            let user = try await authService.loadUser(UserID: UserID)
            self.user = user
        }catch let error as NetworkError {
            self.error = error
            print("Error: \(error)")
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
}
