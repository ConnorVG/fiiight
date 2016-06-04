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

    protected uint position;

    /**
     * The vertices.
     */
    protected float[] vertices = [
       -1.0f, -1.0f,
        1.0f, -1.0f,
        0.0f,  1.0f,
    ];

    /**
     * Loads everything necessary.
     */
    public void load()
    {
        string vertexShader = "#version 450 core\n"
                              "layout(location = 0) in vec2 position;\n"
                              "void main() {\n"
                                "gl_Position = vec4(position, 0.0, 1.0);\n"
                              "}";

        string fragmentShader = "#version 450 core\n"
                                "precision highp float;\n"
                                "layout(location = 0) out vec4 colour;\n"
                                "void main() {\n"
                                  "colour = vec4(1.0, 1.0, 1.0, 1.0);\n"
                                "}";

        this.program = Program.create(vertexShader, fragmentShader);
    }

    /**
     * Unloads everything no longer necessary.
     */
    public void unload()
    {
        // ...
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

        glGenBuffers(1, &this.vbo);
        glBindBuffer(GL_ARRAY_BUFFER, this.vbo);
        glBufferData(GL_ARRAY_BUFFER, this.vertices.sizeof, this.vertices.ptr, GL_STATIC_DRAW);

        glGenVertexArrays(1, &this.vao);
        glBindVertexArray(this.vao);

        this.position = glGetAttribLocation(this.program, "position");
        glEnableVertexAttribArray(this.position);
        glVertexAttribPointer(this.position, 2, GL_FLOAT, GL_FALSE, 0, null);

        glClearColor(0.39f, 0.58f, 0.92f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        glDrawArrays(GL_TRIANGLES, 0, 3);

        glDisableVertexAttribArray(this.vao);

        glDeleteVertexArrays(1, &this.vao);
        glDeleteBuffers(1, &this.vbo);

        assert(glGetError() == GL_NO_ERROR, "GL error!");
    }
}
