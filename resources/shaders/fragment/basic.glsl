#version 450 core

precision highp float;

layout(location = 0) in vec4 fragColour;

out vec4 colour;

void main() {
    colour = fragColour;
}
