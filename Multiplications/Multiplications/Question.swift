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
        let multiplicandOffset: Int = 3
        let delta = multiplicandOffset * 2 
        var bottomLimit: Int = max(secondMultiplicand - multiplicandOffset, 2)
        var topLimit: Int = min(secondMultiplicand + multiplicandOffset, 12)
        
        if bottomLimit == 2 {
            topLimit = 2 + delta
        } else if topLimit == 12 {
            bottomLimit = 12 - delta
        }
                
        var wrongAnswers: [Int] = []
        for multiplicand in (bottomLimit...topLimit) where multiplicand != secondMultiplicand {
            wrongAnswers.append(mainMultiplicand * multiplicand)
        }
                        
        (0..<3).forEach { _ in
            let choosenAnswerIndex: Int = Int.random(in: 0..<wrongAnswers.count)
            answers.append(wrongAnswers.remove(at: choosenAnswerIndex))
        }
        
        return answers.shuffled()
    }
}
