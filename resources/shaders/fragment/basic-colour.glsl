#version 450 core

precision highp float;

in vec4 fragColour;
out vec4 colour;

void main() {
    colour = vec4(fragColour);
}
