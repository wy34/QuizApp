//
//  ViewController.swift
//  QuizApp
//
//  Created by William Yeung on 4/8/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit

class ViewController: UIViewController, QuizProtocol, UITableViewDataSource, UITableViewDelegate, ResultViewControllerProtocol {

    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var stackViewTrailingContraint: NSLayoutConstraint!
    @IBOutlet var stackViewLeadingContraint: NSLayoutConstraint!
    @IBOutlet var rootStackView: UIStackView!
    
    let model = QuizModel()
    var questions = [Question]()
    var currentQuestionIndex = 0
    var numCorrect = 0
    var resultDialog: ResultViewController?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize teh result dialog
        resultDialog = storyboard?.instantiateViewController(identifier: "ResultVC") as? ResultViewController
        resultDialog?.modalPresentationStyle = .overCurrentContext
        resultDialog?.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // dynamic row heights
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        model.delegate = self
        model.getQuestions()
    }
    
    func slideInQuestion() {
        // set the initial state
        stackViewLeadingContraint.constant = 1000
        stackViewTrailingContraint.constant = -1000
        rootStackView.alpha = 0
        // animate to end state
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.stackViewLeadingContraint.constant = 0
            self.stackViewTrailingContraint.constant = 0
            self.rootStackView.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func slideOutQuestion() {
        // set the initial state
        stackViewTrailingContraint.constant = 0
        stackViewLeadingContraint.constant = 0
        rootStackView.alpha = 1
        view.layoutIfNeeded()
        // animate to end state
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.stackViewLeadingContraint.constant = -1000
            self.stackViewTrailingContraint.constant = 1000
            self.rootStackView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func displayQuestion() {
        // check if there are questions and currentQuestionIndex is not out of bounds
        guard questions.count > 0 && currentQuestionIndex < questions.count else { return }
        // display teh question text
        questionLabel.text = questions[currentQuestionIndex].question
        // reload table view
        tableView.reloadData()
        // slide in question
        slideInQuestion()
    }
    
    // MARK: - QuizProtocol Methods
    
    func questionsRetrieved(_ questions: [Question]) {
        // get refercne to the questions
        self.questions = questions
        
        // check if we should restore the state before showing question 1
        let savedIndex = StateManager.retrieveValue(key: StateManager.questionIndexKey) as? Int
        
        if savedIndex != nil && savedIndex! < self.questions.count {
            // set the current question to the saved index
            currentQuestionIndex = savedIndex!
            
            // retrieve the number correct from storage
            let savedNumCorrect = StateManager.retrieveValue(key: StateManager.numCorrectKey) as! Int
            
            if savedNumCorrect != nil {
                numCorrect = savedNumCorrect
            }
        }
        
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
        var titleText = ""
        // user has tapped on a row and check if the right answer
        let question = questions[currentQuestionIndex]
        if question.correctAnswerIndex! == indexPath.row {
            // user got it right
            print("Correct")
            numCorrect += 1
            titleText = "Correct"
        } else {
            // user got it wrong
            print("Wrong")
            titleText = "Wrong"
        }
        
        //slide out question
        DispatchQueue.main.async {
            self.slideOutQuestion()
        }
        
        // show the popup
        if let resultDialog = resultDialog {
            resultDialog.titleText = titleText
            resultDialog.feedbackText = question.feedback!
            resultDialog.buttonText = "Next"
            
            DispatchQueue.main.async {
                self.present(resultDialog, animated: true, completion: nil)
            }
        }
    }
    
    
    // MARK: - ResultViewControllerProtocol methods
    
    func dialogDismissed() {
        // increment the currentQuestionindex
        currentQuestionIndex += 1
        
        if currentQuestionIndex == questions.count {
            // user has just answer last question
            // show summary dialog
            if let resultDialog = resultDialog {
                resultDialog.titleText = "Summary"
                resultDialog.feedbackText = "You got \(numCorrect) correct out of \(questions.count) questions."
                resultDialog.buttonText = "Restart"
                present(resultDialog, animated: true, completion: nil)
                
                StateManager.clearState()
            }
        } else if currentQuestionIndex > questions.count {
            // restart
            numCorrect = 0
            currentQuestionIndex = 0
            displayQuestion()
        } else if currentQuestionIndex < questions.count {
            // more questions to show
            
            // display the next question
            displayQuestion()
        
            // save state
            StateManager.saveState(numCorrect: numCorrect, questionIndex: currentQuestionIndex)
        }
    }
}

