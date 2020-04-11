//
//  ResultViewController.swift
//  QuizApp
//
//  Created by William Yeung on 4/9/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit

protocol ResultViewControllerProtocol {
    func dialogDismissed()
}

class ResultViewController: UIViewController {

    
    @IBOutlet var dimView: UIView!
    @IBOutlet var dialogView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var feedbackLabel: UILabel!
    @IBOutlet var dismissButton: UIButton!
 
    var titleText = ""
    var feedbackText = ""
    var buttonText = ""
    
    var delegate: ResultViewControllerProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dialogView.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // now that the elements have loaded set the text
        titleLabel.text = titleText
        feedbackLabel.text = feedbackText
        dismissButton.setTitle(buttonText, for: .normal)
        
        // hide the ui elements
        dimView.alpha = 0
        titleLabel.alpha = 0
        feedbackLabel.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // fade in the eleements
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
            self.dimView.alpha = 1
            self.titleLabel.alpha = 1
            self.feedbackLabel.alpha = 1
        }, completion: nil)
    }
    
    
    
    @IBAction func dismissTapped(_ sender: Any) {
        
        // fade out the dim view and then dismiss the popup
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.dimView.alpha = 0
        }) { (completed) in
            // dismiss the vc
            self.dismiss(animated: true, completion: nil)
            self.delegate?.dialogDismissed()
        }
    }
}
