module fiiight.utils.gl;

import derelict.opengl3.gl3 :
    GLint, GLuint, GLenum,
    glCreateShader, glShaderSource, glCompileShader, glGetShaderiv, glDeleteShader,
    glCreateProgram, glAttachShader, glBindFragDataLocation, glLinkProgram, glGetProgramiv,
    GL_FALSE, GL_COMPILE_STATUS, GL_LINK_STATUS, GL_VERTEX_SHADER, GL_FRAGMENT_SHADER;

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
    public static GLuint create(const string source, const GLenum type)
    {
        GLuint shader = glCreateShader(type);

        auto ssp = source.ptr;
        int ssl = cast(int)(source.length);

        glShaderSource(shader, 1, &ssp, &ssl);
        glCompileShader(shader);

        GLint success;
        glGetShaderiv(shader, GL_COMPILE_STATUS, &success);

        assert(success != GL_FALSE, "Failed compiling shader.");

        if (success == GL_FALSE) {
            glDeleteShader(shader);

            return GL_FALSE;
        }

        return shader;
    }
}

struct Program
{
    /**
     * We don't want the default construction to be possible.
     */
    @disable this();

    /**
     * Creates a program.
     *
     * Params:
     *      vertexShader    =       the vertex shader
     *      fragmentShader  =       the fragment shader
     *
     * Returns: the created program id
     */
    public static GLuint create(const string vertexShader, const string fragmentShader)
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
    public static GLuint create(const GLuint vertexShader, const GLuint fragmentShader)
    {
        assert(vertexShader != GL_FALSE, "Vertex shader not set.");
        assert(fragmentShader != GL_FALSE, "Fragment shader not set.");

        GLuint program = glCreateProgram();

        glAttachShader(program, vertexShader);
        glAttachShader(program, fragmentShader);

        glBindFragDataLocation(program, 0, "colour");

        glLinkProgram(program);

        GLint status;
        glGetProgramiv(program, GL_LINK_STATUS, &status);
        assert(status != GL_FALSE, "Failed linking program.");

        return program;
    }
}
