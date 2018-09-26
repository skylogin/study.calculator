//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Awesome S on 18/09/2018.
//  Copyright © 2018 Awesome S. All rights reserved.
//

import Foundation


class CalculatorBrain{
    
    // 누산기
    private var accumulator = 0.0
    
    
    func setoperand(operand: Double){
        accumulator = operand
    }
    
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.Constant(Double.pi)
        ,"e" : Operation.Constant(M_E)
        ,"±" : Operation.UnaryOperation({ -$0 })
        ,"√" : Operation.UnaryOperation(sqrt)
        ,"cos" : Operation.UnaryOperation(cos)
        ,"×" : Operation.BinaryOperation({ $0 * $1 })
        ,"÷" : Operation.BinaryOperation({ $0 / $1 })
        ,"+" : Operation.BinaryOperation({ $0 + $1 })
        ,"−" : Operation.BinaryOperation({ $0 - $1 })
        ,"=" : Operation.Equals
    ]
    
    private enum Operation{
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
   
    func performOperation(symbol: String){
        if let operation = operations[symbol] {
            switch operation{
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = pendingBinaryoperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation(){
        if pending != nil{
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: pendingBinaryoperationInfo?
    
    private struct pendingBinaryoperationInfo{
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    
    
    var result: Double{
        get{
            return accumulator
        }
    }
}
