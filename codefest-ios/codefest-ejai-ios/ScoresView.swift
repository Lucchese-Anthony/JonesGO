//
//  ScoresView.swift
//  codefest-ejai-ios
//
//  Created by Charles Faquin on 10/12/23.
//

import SwiftUI

struct LeaderboardView: View {
    @State var showAlert: Bool = false
    @State private var users: [User] = []
    let session = URLSessionManager()

    var body: some View {
        VStack {
            Text("LEADERBOARD")
                .font(.largeTitle)
                .padding(.bottom, 20)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.bottom, 20)

            List {
                ForEach(users) { user in
                    if let index = users.firstIndex(where: { _user in
                        _user.id == user.id
                    }) {
                        ScoreRowView(user: user, rank: index + 1)
                    } else {
                        ScoreRowView(user: user, rank: nil)
                    }
                    
                }

            }
        }
        .onAppear {
            users = DataManager.users.sorted { $0.score > $1.score }
        }
        .padding()
        .task {
            do {
                let users = try await session.makeRequest([User].self, path: .users, method: .get, body: nil)
                self.users = users.sorted { $0.score > $1.score }
                DataManager.users = users
                print(users)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}


struct ScoreRowView: View {
    var user: User
    var rank: Int?
    
    @State private var animateRow: Bool = false

    var body: some View {
        HStack {
            Text("\(rank ?? 1). \(user.pnumber)")
                .font(.headline)
            Spacer()
            Text("\(user.score) pts")
                .font(.headline)
        }
        .opacity(animateRow ? 1 : 0)
        .offset(y: animateRow ? 0 : 20)
        .onAppear {
            withAnimation(Animation.spring().delay(0.1 * Double(rank ?? 1))) {
                animateRow = true
            }
        }
      
    }
}

struct Team: Identifiable {
    var id = UUID()
    var name: String
    var points: Int
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}
