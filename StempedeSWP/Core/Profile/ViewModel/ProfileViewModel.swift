//
//  ProfileViewModel.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 5/12/24.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published private(set) var loadingState: LoadingState = .finished
    @Published var error: NetworkError?
    @Published private(set) var user: UserResponse?
    let authService: AuthService
    init(authService: AuthService) {
        self.authService = authService
    }
    
    @MainActor
    func loadUser(UserID: String) async throws {
        defer { loadingState = .finished }
        do {
            loadingState = .loading
            let user = try await authService.loadUser(UserID: UserID)
            self.user = user
        }catch let error as NetworkError {
            self.error = error
            print("Error: \(error)")
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
    func loadData(){
        Task(priority: .medium){
            try await loadUser(UserID: KeychainService.shared.retrieveToken(forKey: "UserID") ?? "")
        }
    }
}
