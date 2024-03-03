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
    // MARK: - There should be one device and one command queue per app!
    var device: MTLDevice!
    var commandQueue: MTLCommandQueue!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    private func setup() {
        let device = MTLCreateSystemDefaultDevice()
        self.device = device
        self.view = MTKView(frame: view.frame, device: device)
        
        mtkView.device = device
        
        mtkView.clearColor = Colors.color
        mtkView.delegate = self
        // Creating command queue that holds all command buffers
        commandQueue = self.device.makeCommandQueue()
    }
}

extension ViewController: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) { }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let descriptor = view.currentRenderPassDescriptor else { return }
        
        // Creating command buffer that hold all commands
        let commandBuffer = commandQueue.makeCommandBuffer()
        // Creating command encoder for all our commands ?? WHAT DOES THAT MEAN????
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
        
    }
    
    
}
