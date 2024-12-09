//
//  LoadProfileViewModel.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 5/12/24.
//

import Foundation
class LoadProfileViewModel: ObservableObject {
    let authService: AuthService
    let UserID: String
    @Published private(set) var loadingState: LoadingState = .finished
    @Published var error: NetworkError?
    init(authService: AuthService){
        self.authService = authService
        self.UserID =  KeychainService.shared.retrieveToken(forKey: "UserID") ?? ""
    }
    @MainActor
    func updateProfile(FullName: String, Username: String, Password: String, Email: String, Phone: String, Address: String) async throws {
        defer { loadingState = .finished }
        do{
            loadingState = .loading
             try await authService.updateUser(UserID: UserID,
                                   body: User(
                                    FullName: FullName, Username: Username, Password: Password, Email: Email, Phone: Phone, Address: Address, Status: true, IsExternal: false, ExternalProvider: "None")
            )
        } catch let error as NetworkError {
            self.error = error
            print("Error: \(error)")
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
}
