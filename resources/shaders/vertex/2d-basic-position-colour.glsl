#version 450 core

layout(location = 0) in vec2 position;
layout(location = 1) in vec4 colour;

out vec4 fragColour;

void main() {
    fragColour = colour;
    gl_Position = vec4((position.x * 2.0) - 1.0, (position.y * -2.0) + 1.0, 0.0, 1.0);
}
