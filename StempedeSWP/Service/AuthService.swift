//
//  AuthService.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 3/12/24.
//

import Foundation

struct UserResponse : Codable, Equatable {
    let UserID: Int
    let FullName: String
    let Username: String
    let Password: String
    let Email: String
    let Phone: String
    let Address: String
    let Status: Bool
    let IsExternal: Bool
    let ExternalProvider: String
}
struct User: Codable {
    let FullName: String
    let Username: String
    let Password: String
    let Email: String
    let Phone: String
    let Address: String
    let Status: Bool
    let IsExternal: Bool
    let ExternalProvider: String
}

struct LoginBody: Codable {
    let Username: String
    let Password: String
}

struct LoginResponse: Codable {
    let message: String
    let token: String
    let user: UserResponse
}
//Main functionalities
protocol AuthServiceProtocol {
    func register(body: User) async throws
    func login(body: LoginBody) async throws
    func updateUser(UserID:String, body: User) async throws
}

class AuthService: AuthServiceProtocol, ObservableObject {
    
    @Published var isAuthenticated: Bool = false
    private let keychainService: KeychainService
    let httpClient: HTTPClient
    init(keychainService: KeychainService, httpClient: HTTPClient) {
        self.keychainService = keychainService
        self.httpClient = httpClient
        // Retrieve token from Keychain
            if let token = keychainService.retrieveToken(forKey: "authToken") {
                // Set isAuthenticated to true if a valid token exists
                isAuthenticated = !token.isEmpty
            }
    }
    @MainActor
    func register(body: User) async throws {
        guard let jsonData = try? JSONEncoder().encode(body) else {
            print("DEBUG: Error in decoding jsonData in Login Body")
            return
        }
        let registerRequest = Request(endpoint: .auth, pathComponents: ["register"])
        let registerResource = Resource(url: registerRequest.url!, method: .post(jsonData), modelType: MessageResponse.self)
        let response = try await httpClient.load(registerResource)
        if response.message != nil {
            try await login(body: LoginBody(Username: body.Username, Password: body.Password))
        }
    }
    @MainActor
    func login(body: LoginBody) async throws {
        guard let jsonData = try? JSONEncoder().encode(body) else {
            print("DEBUG: Error in decoding jsonData in Login Body")
            return
        }
        let loginRequest = Request(endpoint: .auth, pathComponents: ["login"])
        let loginResource = Resource(url: loginRequest.url!, method: .post(jsonData), modelType: LoginResponse.self)
        let response = try await httpClient.load(loginResource)
        await keychainService.save(token: response.token, forKey: "authToken");
        await keychainService.save(token: String(response.user.UserID), forKey: "UserID");
        await keychainService.save(token: response.user.Email, forKey: "Email")
        isAuthenticated = true
    }
    @MainActor
    func updateUser(UserID:String, body: User) async throws {
        guard let jsonData = try? JSONEncoder().encode(body) else {
            print("DEBUG: Error in decoding jsonData in Login Body")
            return
        }
        let updateUserRequest = Request(endpoint: .auth, pathComponents: [UserID])
        let updateUserResource = Resource(url: updateUserRequest.url!, method: .put(jsonData), modelType: MessageResponse.self)
        let response = try await httpClient.load(updateUserResource)
        print(response.message ?? "haha")
    }
    @MainActor
    func loadUser(UserID: String) async throws -> UserResponse {
        let loadUserRequest = Request(endpoint: .auth, pathComponents: ["user", UserID])
        let loadUserResource = Resource(url: loadUserRequest.url!, method: .get, modelType: UserResponse.self)
        let response = try await httpClient.load(loadUserResource)
        return response
    }
    
    @MainActor
    func logout() {
        self.isAuthenticated = false
            keychainService.clearAllKeys()
    }
}
