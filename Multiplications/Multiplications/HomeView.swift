//
//  HomeView.swift
//  Multiplications
//
//  Created by Lorenzo Ilardi on 15/04/25.
//

import SwiftUI

struct HomeView: View {
    private let appTittle: String = "Multiplications!"
    private let tableRange: ClosedRange<Int> = 2...12
    
    @State private var choosenTable: Int = 2
    @State private var viewState: ViewState = .starting
    @State private var secondMultiplicand: Int = 1
    @State private var numberOfQuestions: Int = 10
    @State private var answeredQuestions: Int = 0
    @State private var currentQuestionNumber: Int = 1
    @State private var questions: [Question] = []
    @State private var score: Int = 0
    
    private var gameIsOver: Bool {
        return answeredQuestions == numberOfQuestions
    }
    
    private var lastQuestion: Question? {
        questions.last
    }
    
    var body: some View {
        switch viewState {
        case .starting:
            startingContentView
        case .playing:
            playingContentView
                .onAppear {
                    questions.append(generateNewQuestion())
                }
        }
    }
    
    private func answerButtonDidTap(answerIndex: Int) {
        answeredQuestions += 1
        if checkAnswerRightfulness(at: answerIndex) {
            score += 1
        }
        
        goToNextQuestion()
    }
}

private extension HomeView {
    func startGame() {
        viewState = .playing
    }
    
    func goToNextQuestion() {
        guard !gameIsOver else {
            return
        }
        
        currentQuestionNumber += 1
        questions.append(generateNewQuestion())
    }
    
    func generateNewQuestion() -> Question {
        secondMultiplicand = tableRange.randomElement() ?? 1
        return Question(
            mainMultiplicand: choosenTable,
            secondMultiplicand: secondMultiplicand)
    }
    
    func checkAnswerRightfulness(at chosenIndex: Int) -> Bool {
        guard let lastQuestion else {
            return false
        }
        
        return lastQuestion.answers[chosenIndex] == lastQuestion.rightAnswer
    }
}

private extension HomeView {
    enum ViewState {
        case starting
        case playing
    }
    
    var startingContentView: some View {
        return ZStack {
            appGradient
            AnimatedXBackground()
            VStack {
                Spacer()
                
                Text(appTittle)
                    .font(.largeTitle)
                Spacer()
                
                HStack {
                    Spacer()
                    Text("Start")
                    Image(systemName: "chevron.right")
                    Spacer()
                }
                .frame(width: .infinity)
                .padding()
                .background(.thinMaterial)
                .clipShape(.rect(cornerRadius: 10))
                .padding(.horizontal, 20)
                .onTapGesture {
                    viewState = .playing
                }
                
                VStack {
                    Text("Choose a table to exercise with:")
                        .font(.subheadline)
                    tablePicker
                }
                .padding(.vertical, 20)
                .background(.thinMaterial)
                
                VStack {
                    Text("Choose the number of questions:")
                        .font(.subheadline)
                    questionPicker
                }
                .padding(.vertical, 20)
                .background(.thinMaterial)
            }
        }
    }
    
    var playingContentView: some View {
        return ZStack {
            appGradient
            
            VStack {
                topViewBar
                
                Spacer()
                
                VStack(spacing: -35) {
                    HStack(spacing: 5) {
                        Text(lastQuestion?.mainMultiplicand.description ?? "")
                            .frame(width: 130, alignment: .trailing)
                            .roundedShadowed(textSize: 100)
                        Text("x")
                            .roundedShadowed(textSize: 50)
                            .frame(width: 50)
                    }
                    
                    HStack {
                        Text(lastQuestion?.secondMultiplicand.description ?? "")
                            .frame(width: 130, alignment: .trailing)
                            .roundedShadowed(textSize: 100)
                        Text("=")
                            .roundedShadowed(textSize: 50)
                            .frame(width: 50)
                    }
                }
                
                Spacer()
                
                GridStack(
                    rows: 2,
                    columns: 2,
                    rowSpacing: 20,
                    columnsSpacing: 20) { row, column in
                        Text(lastQuestion?.answers[(2 * row) + column].description ?? "")
                            .frame(width: 120, height: 100)
                            .colorfulTextBox(textSize: 50, backgroundColor: .blue)
                            .onTapGesture {
                                answerButtonDidTap(answerIndex: (2 * row) + column)
                            }
                            .disabled(gameIsOver)
                    }
            }
            .padding(.bottom, 50)
        }
    }
    
    var tablePicker: some View {
        Picker(selection: $choosenTable) {
            ForEach(tableRange, id: \.self) { element in
                Text(element.description)
            }
        } label: {
            Text("Choose a table")
        }
        .pickerStyle(.palette)
        .frame(height: 10)
        .padding()
    }
    
    var questionPicker: some View {
        Picker(selection: $numberOfQuestions) {
            ForEach([5, 10, 20], id: \.self) { element in
                Text(element.description)
            }
        } label: {
            Text("Choose the number of questions:")
        }
        .pickerStyle(.palette)
        .frame(height: 10)
        .padding()
    }
    
    var appGradient: some View {
        LinearGradient(
            colors: [.pink, .yellow, .cyan],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    var topViewBar: some View {
        HStack {
            scoreCounter
            Spacer()
            roundCounter
        }
        .padding(.horizontal)
    }
    
    var roundCounter: some View {
        VerticalTextBox(topText: "\(currentQuestionNumber) / \(numberOfQuestions)", bottomText: "rounds", horizontalAlignment: .trailing)
    }
    
    var scoreCounter: some View {
        VerticalTextBox(topText: "\(score)", bottomText: "score", horizontalAlignment: .leading)
    }
}

#Preview {
    HomeView()
}
