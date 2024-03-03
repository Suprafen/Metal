//
//  ViewController.swift
//  FirstSteps
//
//  Created by Ivan Pryhara on 03/03/2024.
//

import UIKit
import MetalKit

enum Colors {
    static let color = MTLClearColorMake(0.1,
                                         0.5,
                                         0.7,
                                         1)
}

class ViewController: UIViewController {

    var mtkView: MTKView {
        return view as! MTKView
    }

    var renderer: Renderer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    private func setup() {
        guard let device = MTLCreateSystemDefaultDevice() else { fatalError("Device was not recognized!") }
        
        renderer = Renderer(device: device)
        
        self.view = MTKView(frame: view.frame, device: renderer.device)
        
        mtkView.clearColor = Colors.color
        mtkView.delegate = renderer
    }
}
