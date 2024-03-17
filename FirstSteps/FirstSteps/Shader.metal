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
};

struct VertexOut {
    float4 position [[ position]];
    float4 color;
};

//vertex function
vertex VertexOut vertex_shader(const VertexIn vertexIn [[ stage_in ]]  ) {
    VertexOut vertexOut;
    vertexOut.position = vertexIn.position;
    vertexOut.color = vertexIn.color;
    
    return vertexOut;
}
// fragment function which returns half4(smaller float form)
fragment half4 fragment_shader(VertexOut vertexIn [[ stage_in ]]) {
    half index = 3;
    half alpha = vertexIn.color.a;
    half gray = (vertexIn.color.r + vertexIn.color.g + vertexIn.color.b) / index;
    
    vertexIn.color = float4(gray, gray, gray, alpha);
    
    return half4(vertexIn.color);
}
