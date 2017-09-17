//
//  CalcLogic.swift
//  Calculator
//
//  Created by Vojtech Kubat on 10/09/2017.
//  Copyright © 2017 Vojtech Kubat. All rights reserved.
//

import Foundation

class CalcLogic {
    private var pendindTyping = false
    private var waitingForSecondInput = false
    
    private var accumulator: Double = 0
    private var pendingOperation: ((Double, Double) -> Double)?
    
    private var wasConstant = false
    
    public var result: Double {
        get {
            return accumulator
        }
    }
    
    internal enum Operation {
        case constant(Double)
        case unary((Double) -> Double)
        case binary((Double, Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.constant(Double.pi),
        "C" : Operation.constant(0.0),
        "+" : Operation.binary(
            {(first: Double, second: Double) -> Double in
                return first + second
            }
        ),
        "-" : Operation.binary({$0 - $1}),
        "✕" : Operation.binary({$0 * $1}),
        "÷" : Operation.binary({ return $0 / $1 }),
        "√" : Operation.unary(
            {(input: Double) -> Double in
                return input.squareRoot()
            }
        ),
        "=" : Operation.equals
    ]
    
    internal func perofrmOperation(key: String, currentOperand: Double, uniqueEntry: Bool) {
        if let operation = operations[key] {
            switch operation {
            case .constant(let value):
                accumulator = value
                wasConstant = true
            case .unary(let function):
                accumulator = function(currentOperand)
                wasConstant = true
            case .binary(let function):
                if (uniqueEntry || wasConstant) {
                    compute(currentOperand: currentOperand)
                }
                pendingOperation = function
                wasConstant = false
            case .equals:
                compute(currentOperand: currentOperand)
                wasConstant = false
            }
        }
    }
    
    private func compute(currentOperand: Double) {
        if (pendingOperation != nil) {
            accumulator = pendingOperation!(accumulator, currentOperand)
            pendingOperation = nil
        } else {
            accumulator = currentOperand
        }
    }
}
