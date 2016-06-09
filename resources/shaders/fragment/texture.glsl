#version 450 core

precision highp float;

layout(location = 0) in vec4 fragColour;
layout(location = 1) in vec2 fragTexture;

uniform sampler2D textureSampler;

out vec4 colour;

void main() {
    colour = fragColour * texture(textureSampler, fragTexture);
}
