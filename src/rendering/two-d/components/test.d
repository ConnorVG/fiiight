module fiiight.rendering.two_d.components.test;

import fiiight.rendering.two_d.component : Component;
import fiiight.utils.gl : Program;

import derelict.opengl3.gl3; // : glGenBuffers, glDeleteBuffers;

import std.stdio : writeln;

class TestComponent : Component
{
    /**
     * The program reference.
     */
    protected uint program;

    /**
     * The vbo reference.
     */
    protected uint vbo;

    /**
     * The vao reference.
     */
    protected uint vao;

    /**
     * The vertices.
     */
    protected float[] vertices = [
         0.0f,  0.5f, // Vertex 1 (X, Y)
         0.5f, -0.5f, // Vertex 2 (X, Y)
        -0.5f, -0.5f, // Vertex 3 (X, Y)
    ];

    /**
     * Loads everything necessary.
     */
    public void load()
    {
        glGenVertexArrays(1, &this.vao);
        glBindVertexArray(vao);

        string vertexShader = "#version 150\n"
                              "in vec2 position;\n"
                              "void main()\n"
                              "{\n"
                                "gl_Position = vec4(position, 0.0, 1.0);\n"
                              "}";

        string fragmentShader = "#version 150\n"
                              "out vec4 colour;\n"
                              "void main()\n"
                              "{\n"
                                "colour = vec4(1.0, 1.0, 1.0, 1.0);\n"
                              "}";

        this.program = Program.create(vertexShader, fragmentShader);

        glGenBuffers(1, &this.vbo);
        glBindBuffer(GL_ARRAY_BUFFER, this.vbo);
        glBufferData(GL_ARRAY_BUFFER, this.vertices.sizeof, &this.vertices, GL_STATIC_DRAW);

        auto position = glGetAttribLocation(this.program, "position");
        glVertexAttribPointer(position, 2, GL_FLOAT, GL_FALSE, 0, null);
        glEnableVertexAttribArray(position);
    }

    /**
     * Unloads everything no longer necessary.
     */
    public void unload()
    {
        glDeleteBuffers(1, &this.vbo);
    }

    /**
     * Update the component.
     *
     * Params:
     *      tick  =        the tick duration
     */
    public void update(const float tick)
    {
        // ...
    }

    /**
     * Render the component.
     *
     * Params:
     *      tick  =        the tick duration
     */
    public void render(const float tick)
    {
        glUseProgram(this.program);

        glBindBuffer(GL_ARRAY_BUFFER, this.vbo);
        glDrawArrays(GL_TRIANGLES, 0, 3);

        assert(glGetError() == GL_NO_ERROR, "GL error!");
    }
}
