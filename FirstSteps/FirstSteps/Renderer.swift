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
    
    var vertices: [Float] = [
         -1,  1, 0,
         -1, -1, 0,
          1, -1, 0,
          1, -1, 0,
          1,  1, 0,
         -1,  1, 0
    ]
    
    var pipelineState: MTLRenderPipelineState?
    var vertextBuffer: MTLBuffer?
    
    init(device: MTLDevice) {
        self.device = device
        // Creating command queue that holds all command buffers
        self.commandQueue = self.device.makeCommandQueue()
        super.init()
        buildModel()
        buildPipelineState()
    }
    
    private func buildModel() {
        vertextBuffer = device.makeBuffer(bytes: vertices,
                                          length: vertices.count * MemoryLayout<Float>.size,
                                          options: [])
    }
    
    private func buildPipelineState() {
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertex_shader")
        let fragmentFunction = library?.makeFunction(name: "fragment_shader")
        
        
        let pipelineDescriptior = MTLRenderPipelineDescriptor()
        pipelineDescriptior.vertexFunction = vertexFunction
        pipelineDescriptior.fragmentFunction = fragmentFunction
        pipelineDescriptior.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptior)
        } catch {
            print("Failed to creat a pipeline state!")
        }
        
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let pipelineState,
              let vertextBuffer,
              let descriptor = view.currentRenderPassDescriptor else { return }
        
        // Creating command buffer that hold all commands
        let commandBuffer = commandQueue?.makeCommandBuffer()
        // Creating command encoder for all our commands ?? WHAT DOES THAT MEAN????
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        
        commandEncoder?.setRenderPipelineState(pipelineState)
        commandEncoder?.setVertexBuffer(vertextBuffer, offset: 0, index: 0)
        
        commandEncoder?.drawPrimitives(type: .triangle,
                                       vertexStart: 0,
                                       vertexCount: vertices.count)
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
