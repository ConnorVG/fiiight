module fiiight.rendering.two_d.components.test;

import fiiight.rendering.two_d.component : Component;
import fiiight.utils.gl : Programs, Program;

import derelict.opengl3.gl3 :
    glGenVertexArrays, glBindVertexArray, glGenBuffers, glBindBuffer, glBufferData,
    glEnableVertexAttribArray, glVertexAttribPointer, glDeleteBuffers, glDeleteVertexArrays,
    glDrawArrays, GL_FLOAT, GL_FALSE, GL_TRIANGLES, GL_ARRAY_BUFFER, GL_STATIC_DRAW;

class TestComponent : Component
{
    /**
     * The programs.
     */
    protected Programs* programs;

    /**
     * The program.
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
       -1.0f, -1.0f,
        1.0f, -1.0f,
        0.0f,  1.0f,
    ];

    /**
     * Loads everything necessary.
     *
     * Params:
     *      programs  =     the programs
     */
    public void load(Programs* programs)
    {
        auto program = programs.get("2d-basic");

        this.programs = programs;
        this.program = program.id;

        glGenVertexArrays(1, &this.vao);
        glBindVertexArray(this.vao);

        glGenBuffers(1, &this.vbo);
        glBindBuffer(GL_ARRAY_BUFFER, this.vbo);
        glBufferData(GL_ARRAY_BUFFER, this.vertices.length * float.sizeof, this.vertices.ptr, GL_STATIC_DRAW);

        glEnableVertexAttribArray(program.attributes["position"]);
        glVertexAttribPointer(program.attributes["position"], 2, GL_FLOAT, GL_FALSE, 0, null);
    }

    /**
     * Unloads everything no longer necessary.
     */
    public void unload()
    {
        glDeleteBuffers(1, &this.vbo);
        glDeleteVertexArrays(1, &this.vao);
    }

    /**
     * Update the component.
     *
     * Params:
     *      tick  =        the tick duration
     */
    public void update(const float tick)
    { /** */ }

    /**
     * Render the component.
     *
     * Params:
     *      tick  =        the tick duration
     */
    public void render(const float tick)
    {
        // need to optimise a way of not always using
        // this because it may already be in use
        // and it's quite an expensive call.
        //
        // this is much faster than a straight glUseProgram though.
        this.programs.use(this.program);

        glBindVertexArray(this.vao);
        glDrawArrays(GL_TRIANGLES, 0, 3);
    }
}
