//
//  LoginViewModel.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 3/12/24.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var loadingState: LoadingState = .finished
    @Published var Username = ""
    @Published var Password = ""
    @Published var error: NetworkError?
    let authSevice: AuthService
    init(authSevice: AuthService) {
        self.authSevice = authSevice
    }
    @MainActor
    func login() async {
        defer{
            loadingState = .finished
        }
        do{
            loadingState = .loading
            try await authSevice.login(body: LoginBody(Username: Username, Password: Password))
        }catch let error as NetworkError {
            self.error = error
            print("Error: \(error)")
        } catch {
            print("Unexpected error : \(error.localizedDescription)")
        }
      
    }
}
