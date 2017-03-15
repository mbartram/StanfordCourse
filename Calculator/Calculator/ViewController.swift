//
//  ViewController.swift
//  Calculator
//
//  Created by McCormick Bartram on 3/14/17.
//  Copyright © 2017 McCormick & Bartram. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var display: UILabel!
    
    var currentlyTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if currentlyTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            currentlyTyping = true
        }
        
        print("\(digit) was touched")
    }
    var displayValue: Double {
        get {
          return Double(display.text!)!
        }
        set {
            display.text = String (newValue)
        }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        currentlyTyping = false
        if let mathSymbol = sender.currentTitle {
            switch mathSymbol {
            case "π":
                displayValue = Double.pi
            case "√":
                displayValue = sqrt(displayValue)            default:
                break
            }        }
        
    }
    
}

