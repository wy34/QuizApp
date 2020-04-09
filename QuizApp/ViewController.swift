//
//  ViewController.swift
//  QuizApp
//
//  Created by William Yeung on 4/8/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit

class ViewController: UIViewController, QuizProtocol, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    let model = QuizModel()
    var questions = [Question]()
    var currentQuestionIndex = 0
    var numCorrect = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // dynamic row heights
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        model.delegate = self
        model.getQuestions()
    }
    
    func displayQuestion() {
        // check if there are questions and currentQuestionIndex is not out of bounds
        guard questions.count > 0 && currentQuestionIndex < questions.count else { return }
        // display teh question text
        questionLabel.text = questions[currentQuestionIndex].question
        // reload table view
        tableView.reloadData()
    }
    
    // MARK: - QuizProtocol Methods
    
    func questionsRetrieved(_ questions: [Question]) {
        // get refercne to the questions
        self.questions = questions
        
        // display the question
        displayQuestion()
    }

    
    // MARK: - UITableView Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard questions.count > 0 else {
            return 0
        }
        
        if let answers = questions[currentQuestionIndex].answers {
            return answers.count
        } else {
            return 0
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // get a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath)
        // customize it
        let label = cell.viewWithTag(1) as? UILabel
        
        if label != nil {
            let question = questions[currentQuestionIndex]
            
            if question.answers != nil && indexPath.row < question.answers!.count {
                // set the answer text
                label!.text = question.answers![indexPath.row]
            }
        }
        // return cell
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // user has tapped on a row and check if the right answer
        let question = questions[currentQuestionIndex]
        if question.correctAnswerIndex! == indexPath.row {
            // user got it right
            print("Correct")
        } else {
            // user got it wrong
            print("Wrong")
        }
        
        // increment the currentQuestionindex
        currentQuestionIndex += 1
        // display the next question
        displayQuestion()
    }
}

