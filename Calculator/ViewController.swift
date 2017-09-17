//
//  ViewController.swift
//  Calculator
//
//  Created by Vojtech Kubat on 10/09/2017.
//  Copyright © 2017 Vojtech Kubat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    
    private var calcLogic = CalcLogic()
    
    private var pendindTyping = false
    private var decimal = false
    
    @IBAction private func digitTapped(_ sender: UIButton) {
        guard let digit: String = sender.titleLabel?.text else {
            return
        }
        
        var displayedText = display.text ?? "0"
        
        if (digit == ".") {
            decimal = true
            pendindTyping = true
            return
        }
        
        if (digit == "0" && !decimal && displayedText == "0") {
            return
        }
        
        if (pendindTyping) {
            if (decimal && !(display.text?.contains("."))!) {
                displayedText = "\(displayedText).\(digit)"
            } else {
                displayedText = "\(displayedText)\(digit)"
            }
        } else {
            displayedText = digit
            pendindTyping = true
        }
        
        defer {
            display.text = displayedText
        }
    }

    @IBAction private func buttonTapped(_ sender: UIButton) {
        guard let key = sender.titleLabel?.text else {
            return
        }
        
        calcLogic.perofrmOperation(key: key,
                                   currentOperand: Double(display.text ?? "0") ?? 0.0,
                                   uniqueEntry: pendindTyping)
        let result = String(calcLogic.result)
        display.text = result == "0.0" ? "0" : result
        
        pendindTyping = false
        decimal = false
    }
}
