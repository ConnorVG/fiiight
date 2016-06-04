module fiiight.utils.gl;

import derelict.opengl3.gl3 :
    GLenum, glCreateShader, glShaderSource, glCompileShader, glGetShaderiv, glDeleteShader,
    glUseProgram, glCreateProgram, glAttachShader, glBindFragDataLocation, glLinkProgram, glGetProgramiv,
    GL_TRUE, GL_FALSE, GL_COMPILE_STATUS, GL_LINK_STATUS, GL_VERTEX_SHADER, GL_FRAGMENT_SHADER;

import core.memory : GC;

struct Programs
{
    /**
     * The registered programs.
     */
    private Program*[const string] programs;

    private uint using;

    /**
     * We don't want the default construction to be possible.
     */
    @disable this();

    /**
     * Creates a collection of programs.
     *
     * Returns: the programs pointer
     */
    public static Programs* create()
    {
        return cast(Programs*) GC.calloc(Programs.sizeof);
    }

    /**
     * Get a registered program.
     */
    public Program* get(const string name)
    {
        return this.programs[name];
    }

    /**
     * Register a program.
     */
    public void set(const string name, Program* program)
    {
        this.programs[name] = program;
    }

    public void use(uint program)
    {
        if (this.using == program) {
            return;
        }

        this.using = program;

        glUseProgram(program);
    }
}

struct Shader
{
    /**
     * We don't want the default construction to be possible.
     */
    @disable this();

    /**
     * Creates a shader.
     *
     * Params:
     *      source  =       the glsl source
     *      type    =       GL_VERTEX_SHADER or GL_FRAGMENT_SHADER
     *
     * Returns: the created shader id
     */
    public static uint create(const string source, const GLenum type)
    {
        uint shader = glCreateShader(type);

        auto ssp = source.ptr;
        int ssl = cast(int)(source.length);

        glShaderSource(shader, 1, &ssp, &ssl);
        glCompileShader(shader);

        int success;
        glGetShaderiv(shader, GL_COMPILE_STATUS, &success);

        assert(success == GL_TRUE, "Failed compiling shader.");

        if (success != GL_TRUE) {
            glDeleteShader(shader);

            return GL_FALSE;
        }

        return shader;
    }
}

struct Program
{
    /**
     * The program id.
     */
    public uint id;

    /**
     * The attributes.
     */
    public uint[const string] attributes;

    /**
     * We don't want the default construction to be possible.
     */
    @disable this();

    /**
     * Creates a program.
     *
     * Returns: the program pointer
     */
    public static Program* create(uint id)
    {
        Program* program = cast(Program*) GC.calloc(Program.sizeof);

        program.id = id;

        return program;
    }

    /**
     * Creates a program.
     *
     * Params:
     *      vertexShader    =       the vertex shader
     *      fragmentShader  =       the fragment shader
     *
     * Returns: the created program id
     */
    public static uint create(const string vertexShader, const string fragmentShader)
    {
        return create(Shader.create(vertexShader, GL_VERTEX_SHADER), Shader.create(fragmentShader, GL_FRAGMENT_SHADER));
    }

    /**
     * Creates a program.
     *
     * Params:
     *      vertexShader    =       the vertex shader
     *      fragmentShader  =       the fragment shader
     *
     * Returns: the created program id
     */
    public static uint create(const uint vertexShader, const uint fragmentShader)
    {
        assert(vertexShader != GL_FALSE, "Vertex shader not set.");
        assert(fragmentShader != GL_FALSE, "Fragment shader not set.");

        uint program = glCreateProgram();

        glAttachShader(program, vertexShader);
        glAttachShader(program, fragmentShader);

        glBindFragDataLocation(program, 0, "colour");

        glLinkProgram(program);

        int status;
        glGetProgramiv(program, GL_LINK_STATUS, &status);
        assert(status == GL_TRUE, "Failed linking program.");

        return program;
    }
}
