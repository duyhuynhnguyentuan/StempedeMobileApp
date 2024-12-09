//
//  LoginView.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 3/12/24.
//

import SwiftUI


struct LoginView: View {
    @StateObject var viewModel: LoginViewModel
    init(authService: AuthService){
        _viewModel = StateObject(wrappedValue: LoginViewModel(authSevice: authService))
    }

    var body: some View {
        NavigationStack {
            VStack {
                Image(.stempedeBG)
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)

                VStack {
                    TextField("Tên đăng nhập hoặc số điện thoại", text: $viewModel.Username)
                        .autocapitalization(.none)
                        .modifier(TextFieldModifier())
                    
                    SecureField("Mật khẩu", text: $viewModel.Password)
                        .modifier(TextFieldModifier())
                }

                NavigationLink {
                    EmptyView()
                } label: {
                    Text("Quên mật khẩu?")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .padding(.top)
                        .padding(.trailing, 28)
                        .foregroundColor(Color.primary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }

                Button {
                        Task {
                                await viewModel.login()
                        }
                } label: {
                    Text("Đăng nhập")
                        .modifier(ButtonModifier())
                }
                .padding(.vertical)

                Spacer()

                Divider()

                NavigationLink {
                    RegistrationView(authService: viewModel.authSevice)
                     .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3) {
                        Text("Không có tài khoản?")
                        Text("Đăng kí")
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
        }
        .alert(item: $viewModel.error) { error in
               // Create the alert based on the error type
               switch error {
               case .badRequest:
                   return Alert(title: Text("Bad Request"), message: Text("Unable to perform the request."), dismissButton: .default(Text("OK")))
               case .decodingError(let decodingError):
                   return Alert(title: Text("Decoding Error"), message: Text(decodingError.localizedDescription), dismissButton: .default(Text("OK")))
               case .invalidResponse:
                   return Alert(title: Text("Invalid Response"), message: Text("The server response was invalid."), dismissButton: .default(Text("OK")))
               case .errorResponse(let errorResponse):
                   return Alert(title: Text("Lỗi"), message: Text(errorResponse.message ?? "An unknown error occurred."), dismissButton: .default(Text("OK")))
               }
           }
    }
}

#Preview {
    LoginView(authService: AuthService(keychainService: KeychainService.shared, httpClient: HTTPClient.init()))
}


