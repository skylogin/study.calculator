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
    
    private var internalProgram = [AnyObject]()
    
    func setoperand(operand: Double){
        accumulator = operand
        internalProgram.append(operand as AnyObject)
    }
    
    func addUnaryOperation(symbol: String, operation: @escaping (Double) -> Double){
        operations[symbol] = Operation.UnaryOperation(operation)
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
        ,"AC" : Operation.AC
        ,"RESET" : Operation.AC
    ]
    
    private enum Operation{
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
        case AC
    }
   
    func performOperation(symbol: String){
        internalProgram.append(symbol as AnyObject)
        
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
            case .AC:
                clear()
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
    
    typealias PropertyList = AnyObject
    var program: PropertyList {
        get{
            return internalProgram as CalculatorBrain.PropertyList
        }
        set{
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps{
                    if let operand = op as? Double{
                        setoperand(operand: operand)
                    } else if let operation = op as? String{
                        performOperation(symbol: operation)
                    }
                }
            }
        }
    }
    
    private func clear(){
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
    
    var result: Double{
        get{
            return accumulator
        }
    }
}
