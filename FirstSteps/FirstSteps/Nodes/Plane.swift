//
//  Plane.swift
//  FirstSteps
//
//  Created by Ivan Pryhara on 11/03/2024.
//

import MetalKit

class Plane: Node {
    var vertices: [Vertex] = [
        Vertex(position: SIMD3<Float>(-1, 1, 0),  // V0
               color: SIMD4<Float>(1, 0, 0, 1)),
        Vertex(position: SIMD3<Float>(-1, -1, 0), // V1
               color: SIMD4<Float>(0, 1, 0, 1)),
        Vertex(position: SIMD3<Float>(1, -1, 0),  // V2
               color: SIMD4<Float>(0, 0, 1, 1)),
        Vertex(position: SIMD3<Float>(1, 1, 0),   // V3
               color: SIMD4<Float>(1, 0, 1, 1)),

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
                                          length: vertices.count * MemoryLayout<Vertex>.stride,
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
        
        commandEncoder.drawIndexedPrimitives(type: .triangle,
                                             indexCount: indices.count,
                                             indexType: .uint16,
                                             indexBuffer: indexBuffer,
                                             indexBufferOffset: 0)
    }
}
