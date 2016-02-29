//
//  ViewController.swift
//  CAJoystickExample
//
//  Created by Rakesh TA on 24/02/2016.
//  Copyright © 2016 Raptor Soft. All rights reserved.
//

import UIKit
import CAJoystick


final internal class ViewController: UIViewController {

    // MARK: - IB Outlets
    
    @IBOutlet weak var joystickControl: CAJoystickControl!
    
    @IBOutlet weak var xLabel:          UILabel!
    @IBOutlet weak var yLabel:          UILabel!
    
    @IBOutlet weak var aLabel:          UILabel!
    @IBOutlet weak var dLabel:          UILabel!
}


// MARK: View Lifecycle

extension ViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Update initial value display
        joystickControl_valueChanged(joystickControl)
    }
}


// MARK: - Actions

extension ViewController {
    
    @IBAction func joystickControl_valueChanged(sender: CAJoystickControl) {
        NSLog("DEBUG: Value - \(sender.value)")
        xLabel.text = String(format: "x: %+.4f", arguments: [sender.value.dx])
        yLabel.text = String(format: "y: %+.4f", arguments: [sender.value.dy])
        aLabel.text = String(format: "%.4f :a", arguments: [sender.value.angle])
        dLabel.text = String(format: "%.4f :d", arguments: [sender.value.magnitude])
    }
}
