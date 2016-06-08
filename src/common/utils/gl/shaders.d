module common.utils.gl.shaders;

import derelict.opengl3.gl3 :
    glCreateShader, glShaderSource, glCompileShader, glGetShaderiv, glDeleteShader,
    GLenum, GL_VERTEX_SHADER, GL_COMPILE_STATUS, GL_TRUE, GL_FALSE;

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
        int ssl = cast(int) source.length;

        glShaderSource(shader, 1, &ssp, &ssl);
        glCompileShader(shader);

        int success;
        glGetShaderiv(shader, GL_COMPILE_STATUS, &success);

        assert(success == GL_TRUE, "Failed compiling " ~ (type == GL_VERTEX_SHADER ? "vertex" : "fragment") ~ " shader.");

        if (success != GL_TRUE) {
            glDeleteShader(shader);

            return GL_FALSE;
        }

        return shader;
    }
}
