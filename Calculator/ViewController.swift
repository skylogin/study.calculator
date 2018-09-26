//
//  ViewController.swift
//  Calculator
//
//  Created by Awesome S on 12/09/2018.
//  Copyright © 2018 Awesome S. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!
    @IBOutlet weak var history: UITextField!
    
    
    private var userIsInTheMiddleOfTyping = false
    
    private var userIsInTheDotOfTyping = false
    private var userIsInTheZeroOfTyping = false
    
    private var digitFlag: Dictionary<String,Operation> = [
        "." : Operation.noDoubleInput
        ,"0" : Operation.checkLocation
    ]
    
    private enum Operation{
        case noDoubleInput
        case checkLocation
    }
    
    
    @IBAction private func touchDigit(_ sender: UIButton){
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTyping{
            let textCurrentlyInDisplay = display.text!
            
            // .은 2번이상 입력 불가
            // 최초에 .입력시 0이 앞에 붙어야함
            // 0은 .이전에는 2번이상 입력불가
            let length = textCurrentlyInDisplay.count
            
            if let operation = digitFlag[digit] {
                switch operation{
                case .noDoubleInput:
                    if !userIsInTheDotOfTyping{
                        userIsInTheDotOfTyping = true
                        if length == 0{
                            display.text = "0" + digit
                        } else{
                            display.text = textCurrentlyInDisplay + digit
                        }
                    }
                case .checkLocation:
                    if !userIsInTheZeroOfTyping{
                        userIsInTheZeroOfTyping = true
                        
                        if textCurrentlyInDisplay != "0"{
                            display.text = textCurrentlyInDisplay + digit
                        } else{
                            display.text = "0"
                        }
                    } else{
                        if userIsInTheDotOfTyping{
                           display.text = textCurrentlyInDisplay + digit
                        }
                        
                    }
                }
            } else{
                display.text = textCurrentlyInDisplay + digit
            }
            
            
            
        } else{
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
        
        historyValue = digit
    }
    
    private var displayValue: Double{
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    private var historyValue: String{
        get{
            return String(history.text!)
        }
        set{
            history.text = history.text! + String(newValue)
        }
    }
    
    
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping{
            brain.setoperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
            
            userIsInTheDotOfTyping = false
            userIsInTheZeroOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle{
            brain.performOperation(symbol: mathematicalSymbol)
            historyValue = mathematicalSymbol
        }
        displayValue = brain.result
    }
    
}
