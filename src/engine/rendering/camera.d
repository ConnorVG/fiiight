module engine.rendering.camera;

import derelict.opengl3.gl3 : glUniformMatrix4fv, GL_TRUE;

import gl3n.linalg : Vector, mat4;

import core.memory : GC;

alias vec3 = Vector!(float, 3);
alias vec2r = Vector!(real, 2);

struct Camera
{
    /**
     * The camera position.
     */
    public vec3 position;

    /**
     * The camera rotation.
     */
    public vec2r rotation;

    /**
     * We don't want the default construction to be possible.
     */
    @disable this();

    /**
     * Creates an instance of camera.
     *
     * Returns: a pointer to the camera instance
     */
    public static Camera* create(
        vec3 position = vec3(0f, 0f, 0f),
        vec2r rotation = vec2r(0f, 0f)
    ) {
        Camera* data = cast(Camera*) GC.malloc(Camera.sizeof);

        data.position = position;
        data.rotation = rotation;

        return data;
    }

    /**
     * Apply the camera matrix.
     *
     * Params:
     *      unifView  =     the position of the view uniform
     */
    public void apply(const int unifView)
    {
        glUniformMatrix4fv(unifView, 1, GL_TRUE, this.matrix.value_ptr);
    }

    /**
     * Get the matrix.
     *
     * Returns: the matrix
     */
    @property matrix()
    {
        return mat4.identity.translate(this.position).rotatez(-this.rotation.x).rotatex(this.rotation.y);
    }
}
