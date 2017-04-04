//
//  CalculatorEngine.swift
//  Calculator
//
//  Created by Mac Bartram on 3/19/17.
//  Copyright © 2017 McCormick & Bartram. All rights reserved.
//




//Model
import Foundation

private enum DescriptionTree<String> {
    case empty
    indirect case node(DescriptionTree,String,DescriptionTree)
}

struct CalculatorBrain {
    
    private var accumulator: Double?
    private var pendingBinaryOperation: PendingBinaryOperation?
    private var history = [String]()
    var description: String {
        get {
            return history.joined()
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
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            
            if history.contains("Description") {
                history.removeAll()
            }
            if accumulator != nil {
                history.append(String(accumulator!))
             }
                history.append(symbol)
            
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
                performPendingBinaryOperation()
            case .equals:
                performPendingBinaryOperation()
                history.removeLast()
                history.append("=  ")
            case .clear:
                accumulator = 0
                history.removeAll()
                history.append("Description")
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
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    var result: Double? {
        get{
            return accumulator
        }
    }
    
}

