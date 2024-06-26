//
//  Plane.swift
//  FirstSteps
//
//  Created by Ivan Pryhara on 11/03/2024.
//

import MetalKit

class Plane: Node, Renderable {
    var vertices: [Vertex] = [
        Vertex(position: SIMD3<Float>(-1, 1, 0),  // V0
               color: SIMD4<Float>(1, 0, 0, 1), 
               texture: SIMD2<Float>(0,1)),
        
        Vertex(position: SIMD3<Float>(-1, -1, 0), // V1
               color: SIMD4<Float>(0, 1, 0, 1),
               texture: SIMD2<Float>(0,0)),
        
        Vertex(position: SIMD3<Float>(1, -1, 0),  // V2
               color: SIMD4<Float>(0, 0, 1, 1), 
               texture: SIMD2<Float>(1,0)),
        
        Vertex(position: SIMD3<Float>(1, 1, 0),   // V3
               color: SIMD4<Float>(1, 0, 1, 1), 
               texture: SIMD2<Float>(1,1)),
    ]
    
    var indices: [UInt16] = [
        0, 1, 2,
        2, 3, 0
    ]
    
    var pipelineState: MTLRenderPipelineState!
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    
    var fragmentFunctionName: String = "fragment_shader"
    var vertexFunctionName: String = "vertex_shader"
    
    var constants = Constants()
    
    var time: Float = 0.0
    
    var texture: MTLTexture?
    
    var vertexDescriptor: MTLVertexDescriptor {
        let vertexDescriptor = MTLVertexDescriptor()
        // Describe a position data
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        // Describe a color attribute
        vertexDescriptor.attributes[1].format = .float4
        // The offset is SIMD3<Float> i.e. float3 from the begining
        // This was the size of the position attribute
        vertexDescriptor.attributes[1].offset = MemoryLayout<SIMD3<Float>>.stride
        vertexDescriptor.attributes[1].bufferIndex = 0
        
        vertexDescriptor.attributes[2].format = .float2
        // Texture attribute is offset by the size of the two entries
        vertexDescriptor.attributes[2].offset = MemoryLayout<SIMD3<Float>>.stride + MemoryLayout<SIMD4<Float>>.stride
        vertexDescriptor.attributes[2].bufferIndex = 0
        
        // Tell the vertex descriptor the size information held for each vertex
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        
        return vertexDescriptor
    }
    
    init(device: MTLDevice) {
        super.init()
        buildBuffers(device: device)
        pipelineState = buildPipelineState(device: device)
    }
       
    init(device: MTLDevice, imageName: String) {
        super.init()
        if let texture = setTexture(device: device, imageName: imageName) {
            self.texture = texture
            fragmentFunctionName = "textured_fragment"
        }
        
        buildBuffers(device: device)
        pipelineState = buildPipelineState(device: device)
    }
    
    private func buildBuffers(device: MTLDevice) {
        vertexBuffer = device.makeBuffer(bytes: vertices,
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
        
        commandEncoder.setRenderPipelineState(pipelineState)
        
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder.setVertexBytes(&constants,
                                      length: MemoryLayout<Constants>.stride,
                                      index: 1)
        
        commandEncoder.setFragmentTexture(texture, index: 0)
        
        commandEncoder.drawIndexedPrimitives(type: .triangle,
                                             indexCount: indices.count,
                                             indexType: .uint16,
                                             indexBuffer: indexBuffer,
                                             indexBufferOffset: 0)
    }
}

extension Plane {
    struct Constants {
        var animatedBy: Float = 0.0
    }
}

extension Plane: Texturable {
    
}
