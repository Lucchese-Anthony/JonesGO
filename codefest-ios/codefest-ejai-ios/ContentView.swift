//
//  ContentView.swift
//  codefest-ejai-ios
//
//  Created by Charles Faquin on 10/12/23.
//

import SwiftUI
import AVKit

struct ContentView: View {
    
    @State var locationManager = LocationManager()
    @State private var selectedTab = 1
    
    @State var isLoggedIn: Bool = false
    @State var pNumber = ""
    
    
    let session = URLSessionManager()
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                
                Text("Home Stuff")
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                    .tag(0)
                
                MapView()
                    .tabItem {
                        Image(systemName: "map")
                        Text("Map")
                    }
                    .tag(1)
                    .environment(locationManager)
                
                LeaderboardView()
                    .tabItem {
                        Image(systemName: "list.bullet.rectangle")
                        Text("Leaderboard")
                    }
                    .tag(2)
                
                Text("Settings")
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                    .tag(3)
            }
            if !isLoggedIn {
                VStack {
                    TextField("Enter P#", text: $pNumber)
                        .padding()
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    
                    Button {
                        Task {
                            do {
                                let post = User(username: "Whatever", pnumber: "P204902")
                                let data = try? JSONEncoder().encode(post)
                                let user: User = try await session.makeRequest(path: .users, method: .post, body: data)
                                print(user)
                                DataManager.user = user
                                isLoggedIn = true
                            }
                        }
                    } label: {
                        Text("Log In")
                    }
                    
                }
                .background(.ultraThinMaterial)
            }
        }
        .onAppear {
            isLoggedIn = DataManager.user != nil
        }
    }
    
    
}

#Preview {
    ContentView()
}
