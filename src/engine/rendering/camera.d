module engine.rendering.camera;

import derelict.opengl3.gl3 : glUniformMatrix4fv, GL_TRUE;

import gl3n.linalg : Vector, mat4;

import std.parallelism : TaskPool;

import core.memory : GC;

alias vec2 = Vector!(float, 2);

struct Camera
{
    /**
     * The camera position.
     */
    public vec2 position;

    /**
     * The camera rotation.
     */
    public float rotation;

    /**
     * The camera zoom.
     */
    public float zoom;

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
        vec2 position = vec2(0.5f, 0.5f),
        float rotation = 0f,
        float zoom = 1f
    ) {
        Camera* data = cast(Camera*) GC.malloc(Camera.sizeof);

        data.position = position;
        data.rotation = rotation;
        data.zoom = zoom;

        return data;
    }

    /**
     * Update the camera.
     *
     * Params:
     *      tick      =     the tick amount
     *      taskPool  =     the available task pool
     */
    void update(const float tick, TaskPool* taskPool)
    {
        // handle camera effects
        // ...
        // screen shake
        // animated zoom
        // etc.
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
        return mat4.identity.rotatez(-this.rotation)
                            .scale(-this.zoom, -this.zoom, -this.zoom)
                            .translate((this.position.x - 0.5f) * -2.0f, (this.position.y - 0.5f) * 2.0f, 0.0f);
    }
}
