//
//  RegistrationViewModel.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 3/12/24.
//

import Foundation

class RegistrationViewModel: ObservableObject {
    @Published var loadingState: LoadingState = .finished
    @Published var error: NetworkError?
    @Published var email = ""
    @Published var password = ""
    @Published var fullName = ""
    @Published var phoneNumber = ""
    @Published var address = ""
    @Published var username = ""
    let authService: AuthService
    init(authService: AuthService) {
        self.authService = authService
    }
    
    @MainActor
    func register() async throws {
        defer{ loadingState = .finished }
        do{
            loadingState = .loading
          try await authService.register(body: User(FullName: fullName, Username: username, Password: password, Email: email, Phone: phoneNumber, Address: address, Status: true, IsExternal: false, ExternalProvider: "None"))
        }catch let error as NetworkError {
            self.error = error
            print("Error: \(error)")
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
}
