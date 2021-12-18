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
        
        
        
        if let reasult = calculatorManager.calaculateValue(operation: "operation") {
            resultLabel.text = reasult
            print(reasult)
        }
        
        print(calculatorManager.calculationArray)
        
        // Wont allow appending multiple operation buttons into array
        isValidPress = false
    }
    
    @IBAction func equalsButtonClicked(_ sender: Any) {
        
        isValidPress = true
        
        calculatorManager.lastNumber = calculatorManager.currentNumber
        
        if let reasult = calculatorManager.calaculateValue(operation: "equals") {
            resultLabel.text = reasult
            print(reasult)
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
    
}

