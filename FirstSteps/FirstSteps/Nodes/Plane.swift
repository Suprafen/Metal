//
//  Plane.swift
//  FirstSteps
//
//  Created by Ivan Pryhara on 11/03/2024.
//

import MetalKit

class Plane: Node {
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
    
    init(device: MTLDevice) {
        super.init()
        buildBuffers(device: device)
    }
        
    private func buildBuffers(device: MTLDevice) {
        vertextBuffer = device.makeBuffer(bytes: vertices,
                                          length: vertices.count * MemoryLayout<Float>.size,
                                          options: [])
        
        indexBuffer = device.makeBuffer(bytes: indices,
                                        length: indices.count * MemoryLayout<Float>.size,
                                        options: [])
    }
    
    override func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        super.render(commandEncoder: commandEncoder, deltaTime: deltaTime)
        
        guard let indexBuffer else { return }
        
        time += deltaTime
        let animatedBy = abs(sin(time)/2 + 0.5)
        constants.animatedBy = animatedBy
        
        
        commandEncoder.setVertexBuffer(vertextBuffer, offset: 0, index: 0)
        commandEncoder.setVertexBytes(&constants,
                                      length: MemoryLayout<Constants>.stride,
                                      index: 1)
        // === Out of scope of the course !
        var green = animatedBy
        commandEncoder.setFragmentBytes(&green, length: MemoryLayout<Float>.stride, index: 2)
        // ===
        
        commandEncoder.drawIndexedPrimitives(type: .triangle,
                                             indexCount: indices.count,
                                             indexType: .uint16,
                                             indexBuffer: indexBuffer,
                                             indexBufferOffset: 0)
    }
}
