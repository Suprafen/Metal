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
         -1,  1, 0, // v0
         -1, -1, 0, // v1
          1, -1, 0, // v2
          1,  1, 0, // v3
    ]
    
    var indices: [UInt16] = [
        0, 1, 2,
        2, 3, 0
    ]
    
    var pipelineState: MTLRenderPipelineState?
    var vertextBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    
    struct Constants {
        var animatedBy: Float = 0.0
    }
    
    var constants = Constants()
    
    var time: Float = 0.0
    
    var scene: Scene?
    
    init(device: MTLDevice) {
        self.device = device
        // Creating command queue that holds all command buffers
        self.commandQueue = self.device.makeCommandQueue()
        super.init()
        buildPipelineState()
    }
    
    private func buildPipelineState() {
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertex_shader")
        let fragmentFunction = library?.makeFunction(name: "fragment_shader")
        
        
        let pipelineDescriptior = MTLRenderPipelineDescriptor()
        pipelineDescriptior.vertexFunction = vertexFunction
        pipelineDescriptior.fragmentFunction = fragmentFunction
        pipelineDescriptior.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        let vertextDescriptor = MTLVertexDescriptor()
        // Describe a position data
        vertextDescriptor.attributes[0].format = .float3
        vertextDescriptor.attributes[0].offset = 0
        vertextDescriptor.attributes[0].bufferIndex = 0
        // Describe a color attribute
        vertextDescriptor.attributes[1].format = .float4
        // The offset is SIMD3<Float> i.e. float3 from the begining
        // This was the side of the position attribute
        vertextDescriptor.attributes[1].offset = MemoryLayout<SIMD3<Float>>.stride
        vertextDescriptor.attributes[1].bufferIndex = 0
        // Tell the vertext descriptor the size information held for each vertex
        vertextDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        
        pipelineDescriptior.vertexDescriptor = vertextDescriptor
        
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
              let descriptor = view.currentRenderPassDescriptor else { return }
        
        // Creating command buffer that hold all commands
        let commandBuffer = commandQueue?.makeCommandBuffer()
        // Creating command encoder for all our commands ?? WHAT DOES THAT MEAN????
        guard let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor) else { return }
        
        commandEncoder.setRenderPipelineState(pipelineState)
        
        let deltaTime = 1 / Float(view.preferredFramesPerSecond)
        
        scene?.render(commandEncoder: commandEncoder, deltaTime: deltaTime)
        
        commandEncoder.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
