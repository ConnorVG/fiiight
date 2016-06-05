module fiiight.rendering.two_d.components.button;

import fiiight.rendering.two_d.component : Component;
import fiiight.utils.gl : Programs, Program;

import derelict.opengl3.gl3 :
    glGenVertexArrays, glBindVertexArray, glGenBuffers, glBindBuffer, glBufferData, glUniform3f,
    glEnableVertexAttribArray, glVertexAttribPointer, glDeleteBuffers, glDeleteVertexArrays,
    glDrawArrays, GL_FLOAT, GL_FALSE, GL_TRIANGLES, GL_ARRAY_BUFFER, GL_STATIC_DRAW, GL_DYNAMIC_DRAW;

class ButtonComponent : Component
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
     * The colour id.
     */
    protected uint colour;

    /**
     * The vertex vbo reference.
     */
    protected uint vertexVbo;

    /**
     * The colour vbo reference.
     */
    protected uint colourVbo;

    /**
     * The vao reference.
     */
    protected uint vao;

    /**
     * The vertices.
     */
    protected float[] vertices;

    this(float x = 0.0f, float y = 0.0f, float width = 1.0f, float height = 1.0f)
    {
        this.vertices = [
            x, y,
            x, y + height,
            x + width, y,

            x + width, y + height,
            x + width, y,
            x, y + height,
        ];

        import std.stdio;
        writeln(this.vertices);
    }

    /**
     * The colours.
     */
    protected float[] colours = [
        1.0f, 1.0f, 1.0f,
        1.0f, 1.0f, 1.0f,
        1.0f, 1.0f, 1.0f,

        1.0f, 1.0f, 1.0f,
        1.0f, 1.0f, 1.0f,
        1.0f, 1.0f, 1.0f,
    ];

    /**
     * Loads everything necessary.
     *
     * Params:
     *      programs  =     the programs
     */
    public void load(Programs* programs)
    {
        Program* program = programs.get("2d-basic");

        this.programs = programs;
        this.program = program.id;

        programs.use(this.program);

        glGenVertexArrays(1, &this.vao);
        glBindVertexArray(this.vao);

        glGenBuffers(1, &this.vertexVbo);
        glBindBuffer(GL_ARRAY_BUFFER, this.vertexVbo);
        glBufferData(GL_ARRAY_BUFFER, this.vertices.length * float.sizeof, this.vertices.ptr, GL_STATIC_DRAW);

        glEnableVertexAttribArray(program.attributes["position"]);
        glVertexAttribPointer(program.attributes["position"], 2, GL_FLOAT, GL_FALSE, 0, null);

        glGenBuffers(1, &this.colourVbo);
        glBindBuffer(GL_ARRAY_BUFFER, this.colourVbo);
        glBufferData(GL_ARRAY_BUFFER, this.colours.length * float.sizeof, this.colours.ptr, GL_DYNAMIC_DRAW);

        glEnableVertexAttribArray(program.attributes["colour"]);
        glVertexAttribPointer(program.attributes["colour"], 3, GL_FLOAT, GL_FALSE, 0, null);
    }

    /**
     * Unloads everything no longer necessary.
     */
    public void unload()
    {
        glDeleteBuffers(1, &this.colourVbo);
        glDeleteBuffers(1, &this.vertexVbo);
        glDeleteVertexArrays(1, &this.vao);
    }

    public void select()
    {
        this.colours = [
            1.0f, 0.3f, 0.3f,
            1.0f, 0.3f, 0.3f,
            1.0f, 0.3f, 0.3f,

            1.0f, 0.3f, 0.3f,
            1.0f, 0.3f, 0.3f,
            1.0f, 0.3f, 0.3f,
        ];

        glBindBuffer(GL_ARRAY_BUFFER, this.colourVbo);
        glBufferData(GL_ARRAY_BUFFER, this.colours.length * float.sizeof, this.colours.ptr, GL_DYNAMIC_DRAW);
    }

    public void deselect()
    {
        this.colours = [
            1.0f, 1.0f, 1.0f,
            1.0f, 1.0f, 1.0f,
            1.0f, 1.0f, 1.0f,

            1.0f, 1.0f, 1.0f,
            1.0f, 1.0f, 1.0f,
            1.0f, 1.0f, 1.0f,
        ];

        glBindBuffer(GL_ARRAY_BUFFER, this.colourVbo);
        glBufferData(GL_ARRAY_BUFFER, this.colours.length * float.sizeof, this.colours.ptr, GL_DYNAMIC_DRAW);
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
        glDrawArrays(GL_TRIANGLES, 0, cast(int) this.vertices.length / 2);
    }
}
