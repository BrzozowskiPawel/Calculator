//
//  ViewController.swift
//  Calculator
//
//  Created by Paweł Brzozowski on 18/12/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    
    var calculatorManager = CalculatorManager()
    var isValidPress = false
    var clearDisplay = false

    @IBAction func numberButtonClicked(_ sender: UIButton) {
        
        isValidPress = true
        
        if clearDisplay == true {
            resultLabel.text = ""
            clearDisplay = false
        }
        
        resultLabel.text! += sender.titleLabel!.text!
        calculatorManager.currentNumber = Double(resultLabel.text!)!
        
    }
    
    @IBAction func operationButtonOrangeClicked(_ sender: UIButton) {
        clearDisplay = true
        
        if isValidPress {
            
            if calculatorManager.calculationArray.count == 1 {
                calculatorManager.calculationArray.append(Double(sender.tag))
            } else {
                calculatorManager.calculationArray.append(calculatorManager.currentNumber)
                calculatorManager.calculationArray.append(Double(sender.tag))
            }
            
        }
        
        calculatorManager.lastOperation = Double(sender.tag)
        
        
        
        if let result = calculatorManager.calaculateValue(operation: "operation") {
            resultLabel.text = getResultAsString(result: result)
            print(result)
        }
        
        print(calculatorManager.calculationArray)
        
        // Wont allow appending multiple operation buttons into array
        isValidPress = false
    }
    
    func getResultAsString(result: Double?) -> String{
        if let result = result {
            if result.rounded(.up) == result.rounded(.down){
                //number is integer
                return String(Int(result))
            }else{
                //number is not integer
                return String(result)
            }
        } else {
            return ""
        }
    }
    
    @IBAction func equalsButtonClicked(_ sender: Any) {
        
        isValidPress = true
        
        calculatorManager.lastNumber = calculatorManager.currentNumber
        
        if let result = calculatorManager.calaculateValue(operation: "equals") {
            resultLabel.text = getResultAsString(result: result)
            print(result)
        }
    }
    
    @IBAction func decimalButtonClicked(_ sender: Any) {
        if !((resultLabel.text)?.contains("."))! {
            resultLabel.text! += "."
        }
    }
    
    @IBAction func clearClicked(_ sender: Any) {
        // Reseting declared values
        clearDisplay = false
        isValidPress = false
        calculatorManager.clear()
        resultLabel.text = ""
    }
    
    @IBAction func specialButtonPressed(_ sender: UIButton) {
        // +/- operation
        if sender.tag == -1 {
            calculatorManager.currentNumber = calculatorManager.currentNumber * (-1)
            resultLabel.text = String(calculatorManager.currentNumber)
        }
        // % operation
        else if sender.tag == -2 {
            calculatorManager.currentNumber = calculatorManager.currentNumber * (0.01)
            resultLabel.text = String(calculatorManager.currentNumber)
        }
    }
    
}

