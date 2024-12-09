//
//  RegistrationView.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 3/12/24.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject var viewModel: RegistrationViewModel
    init(authService: AuthService){
        _viewModel = StateObject(wrappedValue: RegistrationViewModel(authService: authService))
    }
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack{
            VStack{
                Image(.stempedeBG)
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                VStack{
                    TextField("Email", text: $viewModel.email)
                        .autocapitalization(.none)
                        .modifier(TextFieldModifier())
                    SecureField("Mật khẩu", text: $viewModel.password)
                        .autocapitalization(.none)
                        .modifier(TextFieldModifier())
                    TextField("Username",text:$viewModel.username)
                        .autocapitalization(.none)
                        .modifier(TextFieldModifier())
                    TextField("Tên đầy đủ",text:$viewModel.fullName)
                        .autocapitalization(.words)
                        .modifier(TextFieldModifier())
                    HStack {
                        Text("+84")
                            .foregroundColor(.gray)
                            .padding(.leading, 8)
                        
                        Divider()
                            .frame(height: 30)
                            .padding(.horizontal, 8)

                        TextField("Số điện thoại", text: $viewModel.phoneNumber)
                            .keyboardType(.phonePad)

                    }
                    .modifier(TextFieldModifier())
                    TextField("Địa chỉ",text:$viewModel.address)
                        .autocapitalization(.words)
                        .modifier(TextFieldModifier())
                    
                }
                Button {
                    Task{
                      try await viewModel.register()
                    }
                } label: {
                    Text("Đăng kí")
                        .modifier(ButtonModifier())
                }
                .padding(.vertical)
                // MARK: bottom part
                Spacer()
                Divider()
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 3) {
                        Text("Đã có tài khoản?")
                        
                        Text("Đăng nhập")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(Color.primary)
                    .font(.footnote)
                }
                .padding(.vertical, 16)
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

            .alert(item: $viewModel.error) { error in
                // Handle alert cases
                switch error {
                case .badRequest:
                    return Alert(
                        title: Text("Bad Request"),
                        message: Text("Unable to perform the request."),
                        dismissButton: .default(Text("OK"))
                    )
                case .decodingError(let decodingError):
                    return Alert(
                        title: Text("Decoding Error"),
                        message: Text(decodingError.localizedDescription),
                        dismissButton: .default(Text("OK"))
                    )
                case .invalidResponse:
                    return Alert(
                        title: Text("Invalid Response"),
                        message: Text("The server response was invalid."),
                        dismissButton: .default(Text("OK"))
                    )
                case .errorResponse(let errorResponse):
                    return Alert(
                        title: Text("Lỗi"),
                        message: Text(errorResponse.message ?? "An unknown error occurred."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
    }
}

#Preview {
    RegistrationView(authService: AuthService(keychainService: KeychainService.shared, httpClient: HTTPClient()))
}
