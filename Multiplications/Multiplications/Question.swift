//
//  Question.swift
//  Multiplications
//
//  Created by Lorenzo Ilardi on 15/04/25.
//

struct Question {
    let mainMultiplicand: Int
    let secondMultiplicand: Int
    let rightAnswer: Int
    
    var answers: [Int] = []
    
    init(mainMultiplicand: Int, secondMultiplicand: Int) {
        self.mainMultiplicand = mainMultiplicand
        self.secondMultiplicand = secondMultiplicand
        rightAnswer = mainMultiplicand * secondMultiplicand
        answers = generateAnswers()
    }
    
    private func generateAnswers() -> [Int] {
        var answers: [Int] = [rightAnswer]
        let multiplicandOffset: Int = 2
        
        var bottomLimit: Int = secondMultiplicand - 2
        var topLimit: Int = secondMultiplicand + 2
        
        if bottomLimit < 2 {
            bottomLimit = 2
        }
        
        if topLimit > 12 {
            topLimit = 9
        }
        
        var wrongAnswers: [Int] = []
        for multiplicand in (bottomLimit...topLimit) where multiplicand != secondMultiplicand {
            wrongAnswers.append(mainMultiplicand * multiplicand)
        }
        
        (0..<3).forEach { _ in
            answers.append(wrongAnswers.remove(at: Int.random(in: 0..<wrongAnswers.count)))
        }
        
        return answers.shuffled()
    }
}
