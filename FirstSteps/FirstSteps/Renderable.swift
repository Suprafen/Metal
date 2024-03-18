//
//  Renderable.swift
//  FirstSteps
//
//  Created by Ivan Pryhara on 18/03/2024.
//

import MetalKit

protocol Renderable {
    var pipelineState: MTLRenderPipelineState! { get set }
    var vertexFunctionName: String { get }
    var fragmentFunctionName: String { get }
    var vertexDescriptor: MTLVertexDescriptor { get }
}

extension Renderable {
    // The default method for every Renderable object
    // It take vertex descriptor and vertex and fragment functions
    // !!! -  Each Renderable object will be able to have different vertex and gragment
    // functions and different vertex descriptors.
    func buildPipelineState(device: MTLDevice) -> MTLRenderPipelineState {
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: vertexFunctionName)
        let fragmentFunction = library?.makeFunction(name: fragmentFunctionName)
        
        
        let pipelineDescriptior = MTLRenderPipelineDescriptor()
        pipelineDescriptior.vertexFunction = vertexFunction
        pipelineDescriptior.fragmentFunction = fragmentFunction
        pipelineDescriptior.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        pipelineDescriptior.vertexDescriptor = vertexDescriptor
        
        let pipelineState: MTLRenderPipelineState
        
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptior)
        } catch let error as NSError {
            fatalError("Failed to creat a pipeline state! \(error)")
        }
        
        return pipelineState
    }
}
