//
//  ProfileView.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 5/12/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var routerManager : NavigationRouter
    @Environment(\.colorScheme) var colorScheme
    @State private var confirmationShow = false
    let authService: AuthService
    @StateObject var viewModel: ProfileViewModel
    init(authService: AuthService){
        self.authService = authService
        _viewModel = StateObject(wrappedValue: ProfileViewModel(authService: AuthService(keychainService: KeychainService.shared, httpClient: HTTPClient())))
    }
    var body: some View {
        NavigationStack {
            ZStack {
                // LinearGradient as the background
                LinearGradient(gradient: Gradient(colors: [.purple, .purple.opacity(0.5), .pink]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                    .blur(radius: 1)
                    .opacity(0.3)
                switch viewModel.loadingState {
                case .loading:
                    ProgressView()
                case .finished:
                // Content on top of the gradient
                VStack {
                    Text(viewModel.user?.FullName.initialsFromFirstTwoWords() ?? "N/A")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundStyle(.white)
                        .background {
                            Circle()
                                .fill(Color.purple)
                                .overlay(Circle().stroke(Color.purple.opacity(0.8), lineWidth: 10))
                                .shadow(radius: 15)
                                .frame(width: UIScreen.main.bounds.width / 3.5,
                                       height: UIScreen.main.bounds.width / 3.5)
                        }
                        .padding(.bottom, UIScreen.main.bounds.width / 7)
                        .padding(.top, UIScreen.main.bounds.width / 7)
                    
                    Text(viewModel.user?.FullName ?? "N/A")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                        .foregroundStyle(colorScheme == .dark ? .black : .white)
                    
                    Label(viewModel.user?.Email ?? "N/A", systemImage: "envelope")
                        .imageScale(.small)
                        .padding(.all, 10)
                        .background(Color(.purple).opacity(0.75), in: Capsule())
                    
                    // MARK: - Middle part
                    List {
                        // General
                        Section {
                            //add EditProfile here
                            NavigationLink {
                                if viewModel.user != nil {
                                    LoadProfileView(user: viewModel.user!) // Make sure it's unwrapped or use optional binding
                                }
                            } label: {
                                Text("Thông tin cá nhân")
                            }

                        } header: {
                            Label("General", systemImage: "person.fill")
                        }
                        
                        // Privacy and safety
                        Section {
                            NavigationLink{
                                EmptyView()
                            }label: {
                                Text("Thông báo")
                            }
                            Text("Sử dụng FaceID")
                        } header: {
                            Label("Privacy & Safety", systemImage: "lock.fill")
                        }
                        
                        Section{
                            Button{
                                let telephone = "tel://0835488888"
                                guard let url = URL(string: telephone) else { return }
                                   UIApplication.shared.open(url)
                            }label: {
                                Text("Liên hệ chúng tôi qua SDT")
                            }
                            Button {
                                let email = "mailto:stemkit24@gmail.com"
                                guard let url = URL(string: email) else { return }
                                UIApplication.shared.open(url)
                            } label: {
                                Text("Liên hệ Email")
                            }
                        }header: {
                            Label("Support", systemImage: "questionmark.circle.fill")
                        }
                        Section{
                            Text("Xóa tài khoản")
                                .foregroundStyle(.red)
                            Button("Đăng xuất") {
                                confirmationShow.toggle()
                            }
                            .foregroundStyle(.red)
                            .confirmationDialog("Chắc chắn đăng xuất",
                                                isPresented: $confirmationShow,
                                                titleVisibility: .visible) {
                                Button("Yes", role: .destructive){
                                    withAnimation {
                                        authService.logout()
                                        routerManager.reset()
                                    }
                                }
                            }
                        } header: {
                            Label("Danger Zone", systemImage: "exclamationmark.octagon.fill")
                                .foregroundStyle(.red)
                        }
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                }
                .frame(maxWidth: .infinity)
            }
            }
            .onAppear{
                viewModel.loadData()
            }
        }
        
    }
}

//#Preview {
//    ProfileView()
//}
extension String {
    /// Returns the initials from the first two words in the string.
    func initialsFromFirstTwoWords() -> String {
        // Split the string into words by spaces
        let nameComponents = self.split(separator: " ")
        
        // Extract the first character of the first two components
        let firstInitial = nameComponents.first?.prefix(1) ?? ""
        let secondInitial = nameComponents.dropFirst().first?.prefix(1) ?? ""
        
        return "\(firstInitial)\(secondInitial)"
    }
}
