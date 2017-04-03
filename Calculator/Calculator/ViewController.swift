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
    
    
  
    
    private func changeColor() {
        
    }
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
            }
        } else {
            display.text = digit
            currentlyTyping = true
        }
    
    }
    
    
    private var engine: CalculatorBrain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        
        if currentlyTyping {
            engine.setOperand(displayValue)
            currentlyTyping = false
        }
        if let mathSymbol = sender.currentTitle {
           engine.performOperation(mathSymbol)
        }
        if let result = engine.result {
            displayValue = result
        }
         descriptionLabel.text = engine.description
    }
    
}

