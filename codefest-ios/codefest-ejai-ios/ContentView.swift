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
    }
}

#Preview {
    ContentView()
}
