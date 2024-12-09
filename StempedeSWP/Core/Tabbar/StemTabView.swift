//
//  TabView.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 3/12/24.
//

import SwiftUI

struct StemTabView: View {
    @State private var selectedTab = 0
    let authService: AuthService
    init(authService: AuthService) {
        self.authService = authService
    }
    var body: some View {
        TabView(selection: $selectedTab){
            FeedView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                        .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                }
                .tag(0)
            OrdersView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "clock.fill" : "clock")
                        .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
                }
                .tag(1)
            ProfileView(authService: authService)
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "person.crop.circle.fill" : "person.crop.circle")
                }
                .tag(2)
        }
        .tint(Color.primary)
    }
}

//#Preview {
//    TabView()
//}
