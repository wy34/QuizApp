//
//  QuizModel.swift
//  QuizApp
//
//  Created by William Yeung on 4/8/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import Foundation

protocol QuizProtocol {
    func questionsRetrieved(_ questions: [Question])
}

class QuizModel {
    var delegate: QuizProtocol?
    
    func getQuestions() {
        // fetch the questions
        
        // notify the delegate of the retrieved questions
        delegate?.questionsRetrieved([Question()])
    }
}
