//
//  ViewController.swift
//  FirstSteps
//
//  Created by Ivan Pryhara on 03/03/2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    private func setup() {
        
        self.view.backgroundColor = .blue
        
        
        // Creating a representation of the GPU
//        self.view = MTKView(frame: view.frame, device: renderer.device)
//        
//        metalView.clearColor = Colors.color
//        renderer.scene = Scene(device: renderer.device, size: view.bounds.size)
//        
//        metalView.delegate = renderer
    }
}

