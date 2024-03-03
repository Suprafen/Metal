//
//  Renderer.swift
//  FirstSteps
//
//  Created by Ivan Pryhara on 03/03/2024.
//

import Foundation
import MetalKit

class Renderer: NSObject {
    // MARK: - There should be one device and one command queue per app!
    var device: MTLDevice
    var commandQueue: MTLCommandQueue?
    
    init(device: MTLDevice) {
        self.device = device
        // Creating command queue that holds all command buffers
        self.commandQueue = self.device.makeCommandQueue()
        super.init()
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let descriptor = view.currentRenderPassDescriptor else { return }
        
        // Creating command buffer that hold all commands
        let commandBuffer = commandQueue?.makeCommandBuffer()
        // Creating command encoder for all our commands ?? WHAT DOES THAT MEAN????
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
