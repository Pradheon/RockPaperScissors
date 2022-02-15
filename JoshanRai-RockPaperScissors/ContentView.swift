//
//  ContentView.swift
//  JoshanRai-RockPaperScissors
//
//  Created by Joshan Rai on 2/14/22.
//

import SwiftUI

struct ContentView: View {
    let possibleMoves = ["🪨 Rock", "🧻 Paper", "✂️ Scissors"]
    
    @State private var appChoice = Int.random(in: 0..<3)
    @State private var playerShouldWin = Bool.random()
    
    @State private var playerScore = 0
    @State private var appScore = 0
    @State private var nRoundsPlayed = 0
    
    @State private var displayAlert = false
    @State private var gameOver = false
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.5, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.7, green: 0.25, blue: 0.76), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            VStack {
                Spacer()
                
                // Game title text
                Text("Rock, Paper, Scissors")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                // Game view
                VStack(spacing: 15) {
                    VStack {
                        Text("App Chose: \(possibleMoves[appChoice])")
                            .font(.title2.bold())
                            .foregroundColor(.primary)
                        Text("You Should: \(playerShouldWin ? "Win" : "Lose")")
                            .font(.title3.bold())
                            .foregroundColor(.primary)
                    }
                    ForEach(0..<possibleMoves.count) { number in
                        Button {
                            moveTapped(number)
                        } label: {
                            Text("\(possibleMoves[number])")
                                .font(.title)
                                .padding()
                                .foregroundColor(Color.primary)
                                .background(Color.purple)
                                .cornerRadius(100)
                                .shadow(color: Color.purple, radius: 10, y: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                // Player score text
                Text("Your Score: \(playerScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                    .padding()
                
                // App score text
                Text("App Score: \(appScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
                
                // Round progress text
                Text("Progess: \(nRoundsPlayed) of 8 Rounds")
                    .foregroundColor(.white)
                    .font(.headline)
                
                Spacer()
            }
            
            // Floating Action Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: { displayAlert = true }) {
                        Image(systemName: "questionmark.circle")
                            .font(.title2)
                    }
                    .padding()
                    .foregroundColor(Color.white)
                    .background(Color.black)
                    .clipShape(Circle())
                    .alert("Tutorial", isPresented: $displayAlert) {
                        Button("OK", role: .cancel) {}
                    } message: {
                        Text("""
                             The objective of the game is to select the correct answer.\n\n
                             The App will select either Rock, Paper, or Scissors and ask you to either Win or Lose against its selection.\n
                             Select the correct answer to score a point.\n
                             Selecting the same item as the app will result in a draw and no points will be awarded to either side.\n
                             Selecting the incorrect answer will give a point to the app.\n\n
                             Example:\n
                             App Chose: 🪨 Rock\n
                             You Should: Lose\n
                             Correct Answer to choose: ✂️ Scissors\n\n
                             See how high you can score before completing all rounds.
                             """)
                    }
                }
            }
            .padding(.trailing, 30)
        }
        .alert(alertTitle, isPresented: $displayAlert) {
            Button("Continue", action: askChoice)
        } message: {
            Text("Your score is \(playerScore) correct answers")
                .foregroundColor(.white)
                .font(.title.bold())
        }
        
        .alert(alertTitle, isPresented: $gameOver) {
            Button("Reset", action: reset)
        } message: {
            Text("Try beating your score!")
                .foregroundColor(.white)
                .font(.title.bold())
        }
    }
    
    func nextRound() {
        appChoice = Int.random(in: 0..<3)
        playerShouldWin.toggle()
    }
    
    func moveTapped(_ number: Int) {
        if playerShouldWin == true {
            if appChoice == number { // App and Player chose same
                alertTitle = "Draw"
            }
            else if appChoice == 0 && number == 1 { // App chose Rock, Player chose paper
                alertTitle = "Win"
                playerScore += 1
            }
            else if appChoice == 1 && number == 2 { // App chose Paper, Player chose Scissors
                alertTitle = "Win"
                playerScore += 1
            }
            else if appChoice == 2 && number == 0 { // App chose Scissors, Player chose Rock
                alertTitle = "Win"
                playerScore += 1
            }
            else {
                alertTitle = "Lose"
                playerScore -= 1
                appScore += 1
            }
        } else {
            if appChoice == number {
                alertTitle = "Draw"
            }
            else if appChoice == 0 && number == 2 { // App chose Rock, Player chose Scissors
                alertTitle = "Win"
                playerScore += 1
            }
            else if appChoice == 1 && number == 0 { // App chose Paper, Player chose Rock
                alertTitle = "Win"
                playerScore += 1
            }
            else if appChoice == 2 && number == 1 { // App chose Scissors, Player chose Paper
                alertTitle = "Win"
                playerScore += 1
            }
            else {
                alertTitle = "Lose"
                playerScore -= 1
                appScore += 1
            }
        }
        
        nRoundsPlayed += 1
        displayAlert = true
    }
    
    func askChoice() {
        if nRoundsPlayed == 8 {
            if appScore > playerScore {
                alertTitle = "Defeat"
                alertMessage = "Your Score: \(playerScore) vs. App Score: \(appScore)"
            }
            else {
                alertTitle = "Victory"
                alertMessage = "Your Score: \(playerScore) vs. App Score: \(appScore)"
            }
            reset()
        } else {
            nextRound()
        }
    }
    
    func reset() {
        alertTitle = "Your final score is \(playerScore) correct answers"
        gameOver = true
        nRoundsPlayed = 0
        playerScore = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
