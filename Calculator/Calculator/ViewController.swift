//
//  ViewController.swift
//  Calculator
//
//  Created by McCormick Bartram on 3/14/17.
//  Copyright © 2017 McCormick & Bartram. All rights reserved.
//


//Controller - how it displays

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var display: UILabel! //Outlet - wired up to UI Label
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String (newValue)
        }
    }
    
    var currentlyTyping = false

    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if currentlyTyping {
            let textCurrentlyInDisplay = display.text!
            if !textCurrentlyInDisplay.contains(".") || digit != "."  {
                display.text = textCurrentlyInDisplay + digit
                descriptionLabel.text = engine.description
            }
        } else {
            display.text = digit
            currentlyTyping = true
        }
        
       // print("\(digit) was touched")
    }
    
    
    private var engine: CalculatorBrain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        
        if currentlyTyping {
            engine.setOperand(displayValue)
            descriptionLabel.text = engine.description
            currentlyTyping = false
        }
        if let mathSymbol = sender.currentTitle {
           engine.performOperation(mathSymbol)
        }
        if let result = engine.result {
            displayValue = result
        }
        
    }
    
}

