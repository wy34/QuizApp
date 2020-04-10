//
//  ResultViewController.swift
//  QuizApp
//
//  Created by William Yeung on 4/9/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    
    @IBOutlet var dimView: UIView!
    @IBOutlet var dialogView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var feedbackLabel: UILabel!
    @IBOutlet var dismissButton: UIButton!
 
    var titleText = ""
    var feedbackText = ""
    var buttonText = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // now that the elements have loaded set the text
        titleLabel.text = titleText
        feedbackLabel.text = feedbackText
        dismissButton.setTitle(buttonText, for: .normal)
    }
    
    
    @IBAction func dismissTapped(_ sender: Any) {
        // dismiss the vc
    }
    
}
