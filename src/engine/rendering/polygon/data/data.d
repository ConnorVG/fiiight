module engine.rendering.polygon.data.data;

import gl3n.linalg : Vector, mat4;

alias vec2 = Vector!(float, 2);
alias vec4 = Vector!(float, 4);

class PolygonData
{
    /**
     * The position.
     */
    public vec2 position;

    /**
     * The scale.
     */
    public vec2 scale;

    /**
     * The rotation.
     */
    public float rotation;

    /**
     * The colour.
     */
    public vec4 colour;

    /**
     * Creates an instance of data.
     *
     * Returns: the data instance
     */
    public this(
        vec2 position = vec2(0f, 0f),
        vec2 scale = vec2(1f, 1f),
        float rotation = 0f,
        vec4 colour = vec4(1f, 1f, 1f, 1f)
    ) {
        this.position = position;
        this.scale = scale;
        this.rotation = rotation;
        this.colour = colour;
    }

    /**
     * Get the matrix.
     *
     * Returns: the matrix
     */
    @property matrix()
    {
        return mat4.identity.scale(this.scale.x, this.scale.y, 1.0f)
                            .rotatez(-this.rotation)
                            .translate(this.position.x * 2.0f - 1.0f, this.position.y * -2.0f + 1.0f, 0.0f);
    }
}
