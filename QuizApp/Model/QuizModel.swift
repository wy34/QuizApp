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
        getRemoteJsonFile()
    }
    
    func getLocalJsonFile() {
        // get bundle path to json file
        let path = Bundle.main.path(forResource: "QuestionData", ofType: ".json")
        // double check that path isnt nil
        guard path != nil else {
            print("Couldn't find the json data file")
            return
        }
        // create url object from the path
        let url = URL(fileURLWithPath: path!)
        
        do {
            // get the data from the url
            let data = try Data(contentsOf: url)
            
            // try to decode the data into objects
            let decoder = JSONDecoder()
            let array = try decoder.decode([Question].self, from: data)
            
            // notify the delegate of the parsed objects
            delegate?.questionsRetrieved(array)
        } catch {
            // error: couldnt download the data at that url
        }
    }
    
    
    func getRemoteJsonFile() {
        // get url object
        let urlString = "https://codewithchris.com/code/QuestionData.json"
        
        let url = URL(string: urlString)
        
        guard url != nil else { print("Could create url"); return }
        
        // get url session object
        let session = URLSession.shared
        
        // get data task object
        let dataTask = session.dataTask(with: url!) {(data, response, error) in
            // check that there wasnt an error
            if error == nil && data != nil {
                do {
                    // create json decoder object
                    let decoder = JSONDecoder()
                    // parse the json
                    let array = try decoder.decode([Question].self, from: data!)
                    // use the main thread to notify the vc for ui work
                    DispatchQueue.main.async {
                        // notify the vc
                        self.delegate?.questionsRetrieved(array)
                    }
                } catch {
                    print("Couldnt parse json")
                }
            }
        }
        
        // call resume on data task
        dataTask.resume()
    }
}
