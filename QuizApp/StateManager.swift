//
//  StateManager.swift
//  QuizApp
//
//  Created by William Yeung on 4/9/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import Foundation

class StateManager {
    
    static var numCorrectKey = "NumberCorrectKey"
    static var questionIndexKey = "QuestionIndexKey"
    
    static func saveState(numCorrect: Int, questionIndex: Int) {
        // get a reference to user defaults
        let defaults = UserDefaults.standard
        // save the state data
        defaults.set(numCorrect, forKey: numCorrectKey)
        defaults.set(questionIndex, forKey: questionIndexKey)
    }
    
    static func retrieveValue(key: String) -> Any? {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: key)
    }
    
    static func clearState() {
         // get a reference to user defaults
        let defaults = UserDefaults.standard
        
        defaults.removeObject(forKey: numCorrectKey)
        defaults.removeObject(forKey: questionIndexKey)
    }
}
