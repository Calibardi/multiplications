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
    @State private var viewState: ViewState = .playing
    @State private var secondMultiplicand: Int = 1
    @State private var numberOfQuestions: Int = 10
    @State private var answeredQuestions: Int = 0
    @State private var currentQuestionNumber: Int = 1
    @State private var questions: [Question] = []
    @State private var score: Int = 0
    @State private var answerButtonsState: [AnswerButtonState] = [.normal, .normal, .normal, .normal]
    
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
        updateAnswerButtonState(for: answerIndex)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            resetAnswerButtonsStates()
            answeredQuestions += 1
            if checkAnswerRightfulness(at: answerIndex) {
                score += 1
            }
            
            goToNextQuestion()
        }
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
        
        withAnimation {
            currentQuestionNumber += 1
            questions.append(generateNewQuestion())
        }
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
    
    func goToState(_ state: ViewState) {
        viewState = state
        
        switch viewState {
        case .starting:
            currentQuestionNumber = 1
            answeredQuestions = 0
            score = 0
            questions.removeAll()
        case .playing:
            break
        }
    }
    
    func resetGame() {
        goToState(.starting)
    }

    private func updateAnswerButtonState(for index: Int) {
        if checkAnswerRightfulness(at: index) {
            answerButtonsState[index] = .rightAnswer
        } else {
            answerButtonsState[index] = .wrongAnswer
        }
    }
    
    private func resetAnswerButtonsStates() {
        answerButtonsState = Array(repeating: .normal, count: 4)
    }
}

private extension HomeView {
    enum ViewState {
        case starting
        case playing
    }
    
    enum AnswerButtonState {
        case rightAnswer
        case wrongAnswer
        case normal
        
        var color: Color {
            switch self {
            case .rightAnswer:
                return .green
            case .wrongAnswer:
                return .red
            case .normal:
                return .blue
            }
        }
    }
    
    var startingContentView: some View {
        return ZStack {
            appGradient
            AnimatedXBackground()
            VStack {
                Spacer()
                
                Text(appTittle)
                    .roundedShadowed(textSize: 40)
                Spacer()
                
                HStack {
                    Spacer()
                    Text("Start")
                    Image(systemName: "chevron.right")
                    Spacer()
                }
                .colorfulTextBox(textSize: 20, backgroundColor: .blue)
                .padding(.horizontal, 75)
                .onTapGesture {
                    viewState = .playing
                }
                
                VStack {
                    Text("Choose a table to exercise with:")
                        .roundedShadowed(textSize: 20)
                    tablePicker
                }
                .padding(.vertical, 20)
                
                VStack {
                    Text("Choose the number of questions:")
                        .roundedShadowed(textSize: 20)
                    questionPicker
                }
                .padding(.bottom, 20)
            }
        }
    }
    
    var playingContentView: some View {
        return ZStack {
            appGradient
            
            VStack(spacing: 40) {
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
                            .transition(.asymmetric(
                                insertion: .move(edge: .top).combined(with: .opacity),
                                removal: .move(edge: .bottom).combined(with: .opacity)))
                            .id(currentQuestionNumber)
                        Text("=")
                            .roundedShadowed(textSize: 50)
                            .frame(width: 50)
                    }
                }
                
                Spacer()
                
                VStack {
                    GridStack(
                        rows: 2,
                        columns: 2,
                        rowSpacing: 20,
                        columnsSpacing: 20) { row, column in
                            Text(lastQuestion?.answers[(2 * row) + column].description ?? "")
                                .frame(width: 120, height: 100)
                                .colorfulTextBox(textSize: 50, backgroundColor: answerButtonsState[(2 * row) + column].color)
                                .onTapGesture {
                                    answerButtonDidTap(answerIndex: (2 * row) + column)
                                }
                                .disabled(gameIsOver)
                                .animation(.default, value: answerButtonsState)
                        }
                }

                HStack {
                    Button {
                        resetGame()
                    } label: {
                        Image(systemName: "restart.circle")
                    }
                    Spacer()
                    Button {
                        print("Tapped")
                    } label: {
                        Image(systemName: "trophy.circle")
                    }.opacity(gameIsOver ? 1 : 0)
                }
                .roundedShadowed(textSize: 30)
                .padding(.horizontal, 25)
            }
            .padding(.bottom, 20)
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
        .frame(height: 50)
        .colorfulTextBox(textSize: 50, backgroundColor: .orange)
        .padding(.horizontal, 20)
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
        .frame(height: 50)
        .colorfulTextBox(textSize: 50, backgroundColor: .orange)
        .padding(.horizontal, 20)
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
