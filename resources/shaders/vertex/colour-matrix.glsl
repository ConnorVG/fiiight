#version 450 core

precision highp float;

layout(location = 0) in vec2 position;

layout(location = 1) uniform vec4 colour;
layout(location = 2) uniform mat4 view;
layout(location = 6) uniform mat4 model;

out vec4 fragColour;

void main() {
    fragColour = colour;
    gl_Position = view * model * vec4(position, 0.0, 1.0);
}
