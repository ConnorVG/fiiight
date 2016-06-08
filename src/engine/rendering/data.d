module engine.rendering.data;

import gl3n.linalg : Vector, mat4;

import core.memory : GC;

alias vec2 = Vector!(float, 2);
alias vec2r = Vector!(real, 2);
alias vec4 = Vector!(float, 4);

struct PolygonData
{
    /**
     * The position.
     */
    public vec2 position;

    /**
     * The rotation.
     */
    public vec2r rotation;

    /**
     * The colour.
     */
    public vec4 colour;

    /**
     * We don't want the default construction to be possible.
     */
    @disable this();

    /**
     * Creates an instance of data.
     *
     * Returns: a pointer to the data instance
     */
    public static PolygonData* create(
        vec2 position = vec2(0f, 0f),
        vec2r rotation = vec2r(0f, 0f),
        vec4 colour = vec4(0f, 0f, 0f, 1f)
    ) {
        PolygonData* data = cast(PolygonData*) GC.malloc(PolygonData.sizeof);

        data.position = position;
        data.rotation = rotation;
        data.colour = colour;

        return data;
    }

    /**
     * Get the matrix.
     *
     * Returns: the matrix
     */
    @property matrix()
    {
        return mat4.identity.translate(this.position.x, this.position.y, 0.0f).rotatez(-this.rotation.x).rotatex(this.rotation.y);
    }
}
