//
//  ViewController.swift
//  Calculator
//
//  Created by Paweł Brzozowski on 18/12/2021.
//

import UIKit

class ViewController: UIViewController {

    // Reference to calculatorManager
    var calculatorManager = CalculatorManager()
    // Make sure that this is comapatible for ex. cannot perform normal operation when there is no second number.
    var isValidPress = false
    var clearDisplay = false
    
    // UI stack elements
    var verticalStack = UIStackView()
    var resultLabel = UILabel()
    var zeroButton = UIButton()
    var periodButton = UIButton()
    var equalsButton = UIButton()
    
    // List where buttons are saved to change it apperance
    var listOfButtonsToResize = [UIButton]()
    
    // Texts for buttons
    var textForFirstColumnButtons = ["AC","7", "4",  "1", "0"]
    var textForSecondColumnButtons = ["⁺∕₋", "8", "5", "2", ""]
    var textForThirdColumnButtons = ["%", "9", "6", "3", "." ]
    var textForFourthColumnButtons = ["÷", "x", "-", "+", "="]

    override func viewDidLoad() {
        view.backgroundColor = .black
        setUpMainStackView()
        setUpChildrensOFMainStackView()
    }
    
    // Make buttons round (after they apear).
    override func viewDidAppear(_ animated: Bool) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Set UI for all buttons buut without 0
        for button in listOfButtonsToResize {
            if button.currentTitle! != "0" {
                button.bounds.size.height = button.bounds.size.width
                button.layer.cornerRadius = 0.5 * button.bounds.size.width
            }
            // Set UI for 0 button
            else {
                button.clipsToBounds = true
                button.bounds.size.height = periodButton.bounds.size.height - 12
                button.layer.cornerRadius = 0.25 * button.bounds.size.width
            }
        }
    }
    
    // Setup main StackView containing label and other StackViews
    func setUpMainStackView() {
        view.addSubview(verticalStack)
        
        // Setup main StackView
        verticalStack.axis = .vertical
        verticalStack.distribution = .fillEqually
        verticalStack.spacing = 5
        
        // Place main StackView
        verticalStack.translatesAutoresizingMaskIntoConstraints = false // This is nessesary to constraints to work properly
        verticalStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true // Added top constraint
        verticalStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true // Added bottom constraint
        verticalStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true // Added leading(left) constraint
        verticalStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true // Added trailing(right) constraint
    }
    
    // Setup childrens of main StackView: stakcViews containing buttons or label
    func setUpChildrensOFMainStackView() {
        for i in 0...6 {
            // Set containers specyfication
            let horizontalStackView = UIStackView()
            horizontalStackView.spacing = 10
            horizontalStackView.axis = .horizontal
            
            // Second (counting starts from 0) StackView contains label instead of buttons set
            if i == 1{
                // Add display label
                horizontalStackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
                horizontalStackView.isLayoutMarginsRelativeArrangement =  true
                addDisplayLabel(view: horizontalStackView)
            
            }
            // The rest of StackViews contains buttons
            else if i >= 2 {
                // Add buttons
                addButtonsToStackView(view: horizontalStackView, forRowAt: i)
            }
            // Add StackViews to main StackView but without the last one - it need to be first set up properly.
            if i < 6 {
                verticalStack.addArrangedSubview(horizontalStackView)
                horizontalStackView.distribution = .fillEqually
            }
            // First perform operation to set up last StackView and then add it
            else {
                resizeZeroButton(view: horizontalStackView)
                verticalStack.addArrangedSubview(horizontalStackView)
                verticalStack.distribution = .fillEqually
            }
            
        }
    }
    
    // Resising 0 button insiade of the last child StackView
    func resizeZeroButton(view: UIStackView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addArrangedSubview(zeroButton)
        view.addArrangedSubview(periodButton)
        view.addArrangedSubview(equalsButton)
        
        zeroButton.widthAnchor.constraint(equalTo: self.periodButton.widthAnchor, multiplier: 2.0).isActive = true
        zeroButton.widthAnchor.constraint(equalTo: self.equalsButton.widthAnchor, multiplier: 2.0).isActive = true

    }
    
    // Add display label to the StackView
    func addDisplayLabel(view: UIStackView) {
        resultLabel.font = resultLabel.font.withSize(56)
        resultLabel.textAlignment = .right
        resultLabel.textColor = .white
        resultLabel.text = ""
        view.addArrangedSubview(resultLabel)
    }
    
    // Adding buttons with specyfic properties
    func addButtonsToStackView(view: UIStackView, forRowAt: Int) {
        // First "row" is free space, second is label that's why I substract -2
        let horizontalStackRow = forRowAt-2
        
        // Add 4 more rows of buttons
        for i in 0...3 {
            let button = UIButton(type: .system) // Creating system button
            // Button initial setup
            button.titleLabel?.font = UIFont.systemFont(ofSize: 35, weight: .medium)
            button.setTitleColor(.white, for: .normal)
            
            // All butons in first button row have slightly different color
            if forRowAt == 2 {
                button.backgroundColor = .systemGray
            } else {
                button.backgroundColor = .systemGray2
            }
            
            // Get title for each button in row
            switch i {
            case 0:
                button.setTitle(textForFirstColumnButtons[horizontalStackRow], for: .normal)
                // Special button - clear
                if horizontalStackRow == 0 {
                    // Setup:
                    button.addTarget(self, action: #selector(clearClick), for: .touchUpInside)
                    button.setTitleColor(.black, for: .normal)
                    button.backgroundColor = UIColor(hexString: "A5A5A5")
                    // Add it to the StackView
                    view.addArrangedSubview(button)
                }
                // Another special button - 0 (Is bigger then rest)
                else if horizontalStackRow == 4{
                    button.addTarget(self, action: #selector(numberButtonClick), for: .touchUpInside)
                    button.backgroundColor = UIColor(hexString: "343434")
                    zeroButton = button // Keep track of this button for UI styling. It will be added later to the StackView
                }
                // Normal buttons in this column
                else {
                    // Setup:
                    button.addTarget(self, action: #selector(numberButtonClick), for: .touchUpInside)
                    button.backgroundColor = UIColor(hexString: "343434")
                    // Add to StackView
                    view.addArrangedSubview(button)
                }
            case 1:
                button.setTitle(textForSecondColumnButtons[horizontalStackRow], for: .normal)
                // Special button - +/-
                if horizontalStackRow == 0 {
                    // Setup:
                    button.addTarget(self, action: #selector(plusMinusClick), for: .touchUpInside)
                    button.setTitleColor(.black, for: .normal)
                    button.backgroundColor = UIColor(hexString: "A5A5A5")
                    // Add to StackView
                    view.addArrangedSubview(button)
                }
                // Adding rest of button but without the last button in column
                // Keep in mind that there is no button enxt to 0, later 0 button will tak eup 2x space.
                else if horizontalStackRow != 4{
                    // Setup:
                    button.addTarget(self, action: #selector(numberButtonClick), for: .touchUpInside)
                    button.backgroundColor = UIColor(hexString: "343434")
                    // Add to the StackView
                    view.addArrangedSubview(button)
                }
            case 2:
                button.setTitle(textForThirdColumnButtons[horizontalStackRow], for: .normal)
                // Special button - %
                if horizontalStackRow == 0 {
                    // Setup
                    button.addTarget(self, action: #selector(procentClick), for: .touchUpInside)
                    button.setTitleColor(.black, for: .normal)
                    button.backgroundColor = UIColor(hexString: "A5A5A5")
                    // Add to the StackView
                    view.addArrangedSubview(button)
                }
                // Special button - .
                else if horizontalStackRow == 4 {
                    // Set up
                    button.addTarget(self, action: #selector(periodButtonClick), for: .touchUpInside)
                    button.backgroundColor = UIColor(hexString: "343434")
                    // Keep track of that button - it will be to StackView added later
                    periodButton = button
                }
                // Add regular number buttons in from this column
                else {
                    button.addTarget(self, action: #selector(numberButtonClick), for: .touchUpInside)
                    button.backgroundColor = UIColor(hexString: "343434")
                    view.addArrangedSubview(button)
                }
            case 3:
                // Special button for math operations
                button.setTitle(textForFourthColumnButtons[horizontalStackRow], for: .normal)
                button.backgroundColor = UIColor(hexString: "FEA00A")
                button.titleLabel?.font = UIFont.systemFont(ofSize: 46, weight: .regular)
                // Here = is "special" special buton, it wont have tag and wont have connected to it math operation.
                if horizontalStackRow == 4 {
                    // Setup
                    button.addTarget(self, action: #selector(equalsButtonClick), for: .touchUpInside)
                    // Keep track of this button to UI style it. It will be added to the StackView later
                    equalsButton = button
                }
                // Add "regular" special button that have tag and math operation
                else {
                    // Setup
                    button.addTarget(self, action: #selector(operatorClick), for: .touchUpInside)
                    // Set up tag for each button coresponding with math operation.
                    // Keep in mind that operation are counted from the bottom thats why I have to substract
                    button.tag = 3 - horizontalStackRow
                    // Add to the StackView
                    view.addArrangedSubview(button)
                }
            default:
                print("")
            }
            // Here I am apending button from last StackView to resize 0 button before adding it to the main StackView.
            // This allow me to change UI of buttons easly
            listOfButtonsToResize.append(button)
        }
    }
    
    // Get result of operation or perform last operation once more
    @objc func equalsButtonClick(sender: UIButton) {
        isValidPress = true
        calculatorManager.lastNumber = calculatorManager.currentNumber
        if let result = calculatorManager.calaculateValue(operation: "equals") {
            resultLabel.text = getResultAsString(result: result)
            print(result)
        }
    }
    
    // Special button like =/-/:/x and =
    // After presing it operation will be done (ofc if it's possible)
    @objc func operatorClick(sender: UIButton) {
        
        clearDisplay = true
        if isValidPress {
            print("VALID: tag: \(sender.tag), button: \(sender.currentTitle!)")
            
            if calculatorManager.calculationArray.count == 1 {
                calculatorManager.calculationArray.append(Double(sender.tag))
            }
            else {
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
    
    // Clear the data and displayed label
    @objc func clearClick(sender: UIButton) {
        // Reseting declared values
        clearDisplay = false
        isValidPress = false
        calculatorManager.clear()
        resultLabel.text = ""
    }
    
    // Fucntion for +/-, it changes sign of number
    @objc func plusMinusClick(sender: UIButton) {
        calculatorManager.currentNumber = calculatorManager.currentNumber * (-1)
        resultLabel.text = String(calculatorManager.currentNumber)
    }
    
    // This function returns number times % ( 0.01)
    @objc func procentClick(sender: UIButton) {
        calculatorManager.currentNumber = calculatorManager.currentNumber * (0.01)
        resultLabel.text = String(calculatorManager.currentNumber)
    }
    
    // Number button is responsible for adding digits to create a number
    @objc func numberButtonClick(sender: UIButton) {
        isValidPress = true
        if clearDisplay == true {
            resultLabel.text = ""
            clearDisplay = false
        }
        resultLabel.text! += sender.titleLabel!.text!
        calculatorManager.currentNumber = Double(resultLabel.text!)!
    }
    
    // Allows to add number with decimal places
    @objc func periodButtonClick(sender: UIButton) {
        if !((resultLabel.text)?.contains("."))! {
            resultLabel.text! += "."
        }
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
}
