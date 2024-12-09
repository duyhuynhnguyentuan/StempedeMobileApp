//
//  LoadProfileView.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 5/12/24.
//

import SwiftUI

struct LoadProfileView: View {
    @StateObject var viewModel: LoadProfileViewModel
    var user: UserResponse
    @State private var updatedFullName: String
    @State private var updatedUsername: String
    @State private var updatedEmail: String
    @State private var updatedPhone: String
    @State private var updatedAddress: String
    @EnvironmentObject private var routerManager: NavigationRouter
    @Environment(\.dismiss) private var dismiss
    init(user: UserResponse){
        self.user = user
        _updatedFullName = State(initialValue: user.FullName)
        _updatedUsername = State(initialValue: user.Username)
        _updatedEmail = State(initialValue: user.Email)
        _updatedPhone = State(initialValue: user.Phone)
        _updatedAddress = State(initialValue: user.Address)
        _viewModel = StateObject(wrappedValue: LoadProfileViewModel(authService: AuthService(keychainService: KeychainService.shared, httpClient: HTTPClient())))
    }
    var body: some View {
        switch viewModel.loadingState {
        case .loading:
            ProgressView()
        case .finished:
            VStack(spacing: 20) {
                Text("Chỉnh sửa thông tin cá nhân")
                    .font(.title)
                    .bold()
                
                // Full Name
                TextField("Tên đầy đủ", text: $updatedFullName)
                    .autocapitalization(.words)
                    .modifier(TextFieldModifier())
                // User name
                TextField("Username", text: $updatedUsername)
                    .autocapitalization(.words)
                    .modifier(TextFieldModifier())
                // Email
                TextField("Email", text: $updatedEmail)
                    .autocapitalization(.words)
                    .modifier(TextFieldModifier())
                // Phone Number
                HStack {
                    Text("+84")
                        .foregroundColor(.gray)
                        .padding(.leading, 8)
                    
                    Divider()
                        .frame(height: 30)
                        .padding(.horizontal, 8)
                    
                    TextField("Số điện thoại", text: $updatedPhone)
                        .keyboardType(.phonePad)
                }
                .modifier(TextFieldModifier())
                
                
                // Address
                TextField("Địa chỉ", text: $updatedAddress)
                    .autocapitalization(.words)
                    .modifier(TextFieldModifier())
                
                // Confirm Button
                Button{
                    // Handle the save logic here, you can pass the updated values back to the profile view model or handle it within this view
                    Task{
                        try await viewModel.updateProfile(FullName: updatedFullName, Username: updatedUsername, Password: user.Password, Email: updatedEmail, Phone: updatedPhone, Address: updatedAddress)
                        dismiss()
                    }
                    // Call save function or update API request here
                }label: {
                    Text("Xác nhận")
                        .modifier(ButtonModifier())
                }
                
            }
            .padding()
        }
    }
}

//#Preview {
//    LoadProfileView()
//}
