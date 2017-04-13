//
//  CalculatorEngine.swift
//  Calculator
//
//  Created by Mac Bartram on 3/19/17.
//  Copyright © 2017 McCormick & Bartram. All rights reserved.
//




//Model
import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double?
    private var pendingBinaryOperation: PendingBinaryOperation?
    // private var history = [String]()
    
    var resultIsPending: Bool {
        return pendingBinaryOperation != nil
    }
    var description: String = " "
    //        get {
    //            return history.joined(separator: " ")
    //        }
    
    
    var result: Double? {
        get{
            return accumulator
        }
    }
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
        case clear
    }
    
    private var operations : Dictionary <String,Operation> =
        [
            "π": Operation.constant(Double.pi),
            "e": Operation.constant(M_E),
            "√" : Operation.unaryOperation(sqrt),
            "cos": Operation.unaryOperation(cos),
            "sin": Operation.unaryOperation(sin),
            "tan": Operation.unaryOperation(tan),
            "±": Operation.unaryOperation({-$0}),
            "x": Operation.binaryOperation({$0 * $1}),
            "÷": Operation.binaryOperation({$0 / $1}),
            "-": Operation.binaryOperation({$0 - $1}),
            "+": Operation.binaryOperation({$0 + $1}),
            "x^2": Operation.unaryOperation({$0 * $0}), //def not the best way...
            "=": Operation.equals,
            "C": Operation.clear
    ]
    
    mutating func setOperand(_ operand: Double) {
        if(accumulator != nil) {description = " "}
        //if description.contains("=") || history.contains("...") || history.contains("Description") { history.removeLast() }
        accumulator = operand
        description+=(String(operand))
    }
    func setOperand(variable named: String) {
        
    }
    func evaluate(using variables: Dictionary<String, Double>? = nil) -> (result: Double?, isPending: Bool, description: String) {
        
        return (result, resultIsPending, description)
    }
    mutating func performOperation(_ symbol: String) {
        
        if let operation = operations[symbol] {
            //if history.contains("=") || history.contains("...") || history.contains("Description") { history.removeLast() }
            switch operation {
                
            case .constant(let value):
                accumulator = value
                description+=(symbol)
                
            case .unaryOperation(let function):
                //resultIsPending ?  history.insert(tempSymbol + "(", at: history.count - 1) :  history.insert(tempSymbol + "(", at: 0)
                //resultIsPending ?  description.insert(tempString, at: description.count - 1) :  description.insert(tempString, at: 0)
                if let acc = accumulator {
                    var tempSymbol = symbol
                    if tempSymbol == "±" && acc > 0 {tempSymbol = "-"}
                    tempSymbol+="("
                    
                    resultIsPending ? description.replaceSubrange(<#T##bounds: Range<String.Index>##Range<String.Index>#>, with: tempSymbol + String(acc) ):description = tempSymbol + description
                    description+=(")")
                    
                    accumulator = function(acc)
                    
                }
                
            case .binaryOperation(let function):
                if let acc = accumulator  {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: acc)
                    accumulator = nil
                }
                description+=(symbol)
                performPendingBinaryOperation()
                
            case .equals:
                performPendingBinaryOperation()
                
            case .clear:
                accumulator = 0.0
                description = "Description"
                pendingBinaryOperation = nil
            }
        }
    }
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private struct PendingBinaryOperation {
        let function: (Double,Double) -> Double
        let firstOperand: Double
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
}

