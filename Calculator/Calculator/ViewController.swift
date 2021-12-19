//
//  ViewController.swift
//  Calculator
//
//  Created by Paweł Brzozowski on 18/12/2021.
//

import UIKit

class ViewController: UIViewController {

//    @IBOutlet weak var resultLabel: UILabel!
    
    // Reference to calculatorManager
    var calculatorManager = CalculatorManager()
    // Make sure that this is comapatible for ex. cannot perform normal operation when there is no second number.
    var isValidPress = false
    var clearDisplay = false
    
    
    var verticalStack = UIStackView()
    var resultLabel = UILabel()
    
    var textForFirstColumnButtons = ["AC","7", "4",  "1", "0"]
    var textForSecondColumnButtons = ["⁺∕₋", "8", "5", "2", ""]
    var textForThirdColumnButtons = ["%", "9", "6", "3", "." ]
    var textForFourthColumnButtons = ["÷", "x", "-", "+", "="]
    override func viewDidLoad() {
        view.backgroundColor = .black
        setUpMainStackView()
        setUpChildrensOFMainStackView()
    }
    
    func setUpMainStackView() {
        view.addSubview(verticalStack)
        
        // Setup main StackView
        verticalStack.axis = .vertical
        verticalStack.distribution = .fillEqually
        verticalStack.spacing = 1
        
        verticalStack.translatesAutoresizingMaskIntoConstraints = false // This is nessesary to constraints to work properly
        verticalStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true // Added top constraint
        verticalStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true // Added bottom constraint
        verticalStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true // Added leading(left) constraint
        verticalStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true // Added trailing(right) constraint
    }
    
    func setUpChildrensOFMainStackView() {
        for i in 0...6 {
            let horizontalStackView = UIStackView()
            horizontalStackView.spacing = 1
            horizontalStackView.axis = .horizontal
            horizontalStackView.distribution = .fillEqually
            
            
            if i == 1{
                // Add display label
                horizontalStackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
                horizontalStackView.isLayoutMarginsRelativeArrangement =  true
                addDisplayLabel(view: horizontalStackView)
                
            } else if i >= 2 {
                // Add buttons
                addButtonsToStackView(view: horizontalStackView, forRowAt: i)
            }
            
            verticalStack.addArrangedSubview(horizontalStackView)
        }
    }
    
    func addDisplayLabel(view: UIStackView) {
        resultLabel.font = resultLabel.font.withSize(32)
        resultLabel.textAlignment = .right
        resultLabel.textColor = .white
        resultLabel.text = "DUMMY TEXT"
        view.addArrangedSubview(resultLabel)
    }
    
    func addButtonsToStackView(view: UIStackView, forRowAt: Int) {
        let horizontalStackRow = forRowAt-2
        
        for i in 0...3 {
            let button = UIButton(type: .system) // Adding system button
            button.setTitleColor(.white, for: .normal)
            
            if forRowAt == 2 {
                button.backgroundColor = .systemGray
            } else {
                button.backgroundColor = .systemGray2
            }
            
            view.addArrangedSubview(button)
            
            switch i {
            case 0:
                button.setTitle(textForFirstColumnButtons[horizontalStackRow], for: .normal)
                
                if horizontalStackRow == 0 {
                    // Add clear button
                    print(button.currentTitle!)
                    button.addTarget(self, action: #selector(clearClick(sender:)), for: .touchUpInside)
                }
                
            case 1:
                button.setTitle(textForSecondColumnButtons[horizontalStackRow], for: .normal)
                
                if horizontalStackRow == 0 {
                    // Add +/- button
                    button.addTarget(self, action: #selector(plusMinusClick), for: .touchUpInside)
                }
                
            case 2:
                button.setTitle(textForThirdColumnButtons[horizontalStackRow], for: .normal)
                
                if horizontalStackRow == 0 {
                    // Add % button
                    button.addTarget(self, action: #selector(procentClick), for: .touchUpInside)
                }
                
            case 3:
                button.setTitle(textForFourthColumnButtons[horizontalStackRow], for: .normal)
                button.backgroundColor = .orange
                
                if horizontalStackRow == 3 {
                    button.addTarget(self, action: #selector(equalsButtonClick), for: .touchUpInside)
                } else {
                    button.addTarget(self, action: #selector(operatorClick), for: .touchUpInside)
                }
                
            default:
                print("")
            }
        }
        
    }
    
    @objc func equalsButtonClick(sender: UIButton) {
        print(sender.currentTitle!)
    }
    
    @objc func operatorClick(sender: UIButton) {
        print(sender.currentTitle!)
    }
    
    @objc func clearClick(sender: UIButton) {
        print(sender.currentTitle!)
    }
    
    @objc func plusMinusClick(sender: UIButton) {
        print(sender.currentTitle!)
    }
    
    @objc func procentClick(sender: UIButton) {
        print(sender.currentTitle!)
    }
    
    // Number button is responsible for adding digits to create a number
    @IBAction func numberButtonClicked(_ sender: UIButton) {
        isValidPress = true
        if clearDisplay == true {
            resultLabel.text = ""
            clearDisplay = false
        }
        resultLabel.text! += sender.titleLabel!.text!
        calculatorManager.currentNumber = Double(resultLabel.text!)!
        
    }
    
    // Special button like =/-/:/x and =
    // After presing it operation will be done (ofc if it's possible)
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
        // Wont allow appending multiple operation buttons into array
        isValidPress = false
    }
    
    // Function added to fix error when adding 2 whole numbers resulted in Double result (with 0 in decimal place).
    // This is only to look better
    func getResultAsString(result: Double?) -> String{
        if let result = result {
            // If decimal number is 0 than just cast it into Int
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
    
    // Get result of operation or perform last operation once more
    @IBAction func equalsButtonClicked(_ sender: Any) {
        isValidPress = true
        calculatorManager.lastNumber = calculatorManager.currentNumber
        if let result = calculatorManager.calaculateValue(operation: "equals") {
            resultLabel.text = getResultAsString(result: result)
            print(result)
        }
    }
    
    // Add decimal point to the number
    @IBAction func decimalButtonClicked(_ sender: Any) {
        if !((resultLabel.text)?.contains("."))! {
            resultLabel.text! += "."
        }
    }
    
    // Clear the data and displayed label
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

