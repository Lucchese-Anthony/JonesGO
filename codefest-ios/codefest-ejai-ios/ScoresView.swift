//
//  ScoresView.swift
//  codefest-ejai-ios
//
//  Created by Charles Faquin on 10/12/23.
//

import SwiftUI

struct LeaderboardView: View {
    @State var showAlert: Bool = false
    @State private var scores: [Score] = []
    
    let session = URLSessionManager()

    var body: some View {
        VStack {
            Text("LEADERBOARD")
                .font(.largeTitle)
                .padding(.bottom, 20)

            Button("Update Random Score") {
                if var randomTeam = scores.randomElement() {
                    randomTeam.total += Double(Int.random(in: 10...100))
                    scores.sort { $0.total > $1.total}
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.bottom, 20)

            List {
                ForEach(scores.indices, id: \.self) { index in
                    ScoreRow(score: scores[index], rank: index + 1)
                }
            }
        }
        .onAppear {
            scores = DataManager.scores
        }
        .padding()
        .task {
            do {
                let scores: [Score] = try await session.makeRequest(path: .scores, method: .get, body: nil)
                print(scores)
                DataManager.scores = scores
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
}

struct ScoreRow: View {
    var score: Score
    var rank: Int

    @State private var animateRow: Bool = false

    var body: some View {
        HStack {
            Text("\(rank). \(score.pnumber)")
                .font(.headline)
            Spacer()
            Text("\(score.total) pts")
                .font(.headline)
        }
        .opacity(animateRow ? 1 : 0)
        .offset(y: animateRow ? 0 : 20)
        .onAppear {
            withAnimation(Animation.spring().delay(0.1 * Double(rank))) {
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
