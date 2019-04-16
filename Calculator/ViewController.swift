//
//  ViewController.swift
//  Calculator
//
//  Created by 이덕호 on 13/01/2019.
//  Copyright © 2019 deokho. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleofTyping = false
    
    private var brain = CalculatorBrain()
    
    private var displayValue: Double {
        get {
            // display에 항상 숫자만 입력받을 거라고 가정하는 코드 (만약 hello같은 string이 들어간다면 앱은 크래시 발생)
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleofTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        
        userIsInTheMiddleofTyping = true
    }
    
    @IBAction private func performOperation(_ sender: UIButton) {
        
        if userIsInTheMiddleofTyping {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleofTyping = false
        }

        if let mathMaticalSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathMaticalSymbol)
        }
        displayValue = brain.result
    }
    
    func testMethod(testParam: String) {
        print(testParam)
    }
    
    var savedProgram: CalculatorBrain.PropertyList?
    
    @IBAction func save() {
        savedProgram = brain.program
    }
    
    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
}

