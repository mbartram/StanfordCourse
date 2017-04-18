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
    private var variables = [String:Double]()
    
    var resultIsPending: Bool {
        return pendingBinaryOperation != nil
    }
    private var descriptionInternal: String = " "
    
    var description: String {
        get {
            return descriptionInternal
        }
    }
    
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
        if(accumulator != nil) {descriptionInternal = " "}
        //if description.contains("=") || history.contains("...") || history.contains("Description") { history.removeLast() }
        accumulator = operand
        descriptionInternal+=(String(operand))
    }
    func setOperand(variable named: String) {
      // descriptionInternal += named
    }
    func evaluate(using variables: Dictionary<String, Double>? = nil) -> (result: Double?, isPending: Bool, description: String) {
        
        return (result, resultIsPending, descriptionInternal)
    }
    mutating func performOperation(_ symbol: String) {
        
        if let operation = operations[symbol] {
            //if history.contains("=") || history.contains("...") || history.contains("Description") { history.removeLast() }
            switch operation {
            case .constant(let value):
                accumulator = value
                descriptionInternal+=(symbol)
                
            case .unaryOperation(let function):
                if let acc = accumulator {
                    var tempSymbol = symbol
                    if tempSymbol == "±" && acc > 0 {tempSymbol = "-"}
                    tempSymbol+="("
                    if resultIsPending {
                        let range = descriptionInternal.range(of: String(acc))!
                            descriptionInternal = descriptionInternal.replacingCharacters(in: range, with: tempSymbol + String(acc))
                    } else {
                        descriptionInternal = tempSymbol + descriptionInternal
                    }
                    descriptionInternal+=(")")
                    accumulator = function(acc)
                    
                }
                
            case .binaryOperation(let function):
                if let acc = accumulator  {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: acc)
                    accumulator = nil
                }
                descriptionInternal+=(symbol)
                performPendingBinaryOperation()
                
            case .equals:
                performPendingBinaryOperation()
                
            case .clear:
                accumulator = 0.0
                descriptionInternal = "Description"
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

