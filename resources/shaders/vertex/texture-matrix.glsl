#version 450 core

precision highp float;

layout(location = 0) in vec2 position;
layout(location = 1) in vec2 texture;

layout(location = 2) uniform vec4 colour;
layout(location = 3) uniform mat4 view;
layout(location = 7) uniform mat4 model;

out vec4 fragColour;
out vec2 fragTexture;

void main() {
    fragTexture = vec2(texture.x, texture.y);
    fragColour = colour;
    gl_Position = view * model * vec4(position.x * 2.0 - 1.0, position.y * -2.0 + 1.0, 0.0, 1.0);
}
