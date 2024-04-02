//
//  Shader.metal
//  FirstSteps
//
//  Created by Ivan Pryhara on 09/03/2024.
//

#include <metal_stdlib>
using namespace metal;

struct Constants {
    float animateBy;
};

struct VertexIn {
    float4 position [[ attribute(0)]];
    float4 color [[ attribute(1)]];
    float2 textureCoordinates [[ attribute(2) ]];
};

struct VertexOut {
    float4 position [[ position]];
    float4 color;
    float2 textureCoordinates;
};

//vertex function
vertex VertexOut vertex_shader(const VertexIn vertexIn [[ stage_in ]]  ) {
    VertexOut vertexOut;
    vertexOut.position = vertexIn.position;
    vertexOut.color = vertexIn.color;
    vertexOut.textureCoordinates = vertexIn.textureCoordinates;
    
    return vertexOut;
}
// fragment function which returns half4(smaller float form)
fragment half4 fragment_shader(VertexOut vertexIn [[ stage_in ]]) {
    return half4(vertexIn.color);
}

fragment half4 textured_fragment(VertexOut vertexIn [[ stage_in ]],
                                 sampler sampler_2d [[ sampler(0)]],
                                 // texture in fragment buffer 0(zero)
                                 texture2d<float> texture [[ texture(0) ]]) {
    float4 color = texture.sample(sampler_2d, vertexIn.textureCoordinates);
    return half4(color.r, color.g, color.b, color.a);
}
