//
//  ContentView.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 2/12/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ContentViewModel
    let authService: AuthService
    init(authService: AuthService) {
        self.authService = authService
        _viewModel = StateObject(wrappedValue: ContentViewModel(authService: authService))
    }
    var body: some View {
        Group {
            if viewModel.isAuthenticated {
                StemTabView(authService: viewModel.authService)
                .transition(.blurReplace)
                .onAppear{
                    Task{
                        try await  viewModel.loadUser(UserID: KeychainService.shared.retrieveToken(forKey: "UserID") ?? "")
                    }
                }
                .onChange(of: viewModel.user) {
                    if let user = viewModel.user {
                        if(!user.Status){
                            authService.logout()
                        }
                    }
                }
            } else {
                VStack {
                    LoginView(authService: viewModel.authService)
                }
                .transition(.blurReplace) // Slide transition from left
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .animation(.smooth(duration: 0.5), value: viewModel.isAuthenticated) // Applying animation
    }
}

//#Preview {
//    ContentView()
//}
