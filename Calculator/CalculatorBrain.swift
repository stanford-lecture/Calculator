//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by 이덕호 on 11/02/2019.
//  Copyright © 2019 deokho. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()
    
    
    func setOperand(operand: Double) {
        accumulator = operand
        internalProgram.append(operand as AnyObject)
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(Double.pi),
        "e" : Operation.Constant(M_E),
        "±" : Operation.UnaryOperation({ -$0 }),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "×" : Operation.BinaryOperation({ $0 * $1 }),
        "÷" : Operation.BinaryOperation({ $0 / $1 }),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "-" : Operation.BinaryOperation({ $0 - $1 }),
        "=" : Operation.Equals,
        
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double )
        case Equals
    }
    
    func performOperation(symbol: String) {
        internalProgram.append(symbol as AnyObject)
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
                
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
                
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                
            case .Equals:
               executePendingBinaryOperation()
            }
        }
        
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    typealias PropertyList = AnyObject
    var program: PropertyList {
        get {
            return internalProgram as CalculatorBrain.PropertyList
            // 내부의 데이터구조를 외부의 호출자에게 리턴해주는 것이 이상할 수 있지만
            // 배열은 value 타입이기 때문에 복사가 된다.
            // 결국 복사된 값을 돌려주는 것이기때문에 문제가 발생하지 않는다.
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand: operand)
                    } else if let operation = op as? String {
                        performOperation(symbol: operation)
                    }
                }
            }
            
        }
    }
    
    func clear() {
        accumulator = 0
        pending = nil
        internalProgram.removeAll()
        
    }
    
    
    var result: Double {
        get {
            return accumulator
        }
    }
}

