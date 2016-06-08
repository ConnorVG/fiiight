module engine.rendering.polygon.polygon;

import engine.rendering.camera : Camera;
import engine.rendering.data : PolygonData;
import engine.rendering.texture : Texture;
import common : Programs;

import derelict.opengl3.gl3;

import core.memory : GC;

class Polygon
{
    /**
     * An array of the vertices.
     */
    public const float[] vertices;

    /**
     * The vertex array object id.
     */
    protected uint vao;

    /**
     * The vertex buffer object id.
     */
    protected uint vbo;

    /**
     * Create a new polygon.
     *
     * Params:
     *      vertices  =     the vertex array
     */
    public this(const float[] vertices)
    {
        this.vertices = vertices;
    }

    /**
     * Correctly handle destruction.
     */
    public ~this()
    {
        glDeleteBuffers(1, &this.vbo);
        glDeleteVertexArrays(1, &this.vao);
    }

    /**
     * Generates the VBAs and VBOs.
     *
     * Params:
     *      programs  =     the program collection
     */
    public void load(Programs* programs)
    {
        glGenVertexArrays(1, &this.vao);
        glBindVertexArray(this.vao);

        glGenBuffers(1, &this.vbo);
        glBindBuffer(GL_ARRAY_BUFFER, this.vbo);
        glBufferData(GL_ARRAY_BUFFER, this.vertices.length * float.sizeof, this.vertices.ptr, GL_STATIC_DRAW);
    }

    /**
     * Bind the VBAs and VBOs.
     */
    public void bind() const
    {
        glBindVertexArray(this.vao);
    }

    /**
     * Render the data.
     *
     * Params:
     *      camera  =       the camera
     *      datas   =       the data collection
     */
    public void render(Camera* camera, PolygonData*[] datas) const
    {
        // foreach (PolygonData* data; datas) {
        //     // ...
        // }
    }

    /**
     * Unbinds the VBAs and VBOs.
     */
    public void unbind() const
    {
        glBindVertexArray(0);
    }
}

struct Polygons
{
    /**
     * The registered polygons.
     */
    private Polygon[const string] polygons;

    /**
     * We don't want the default construction to be possible.
     */
    @disable this();

    /**
     * Creates a collection of polygons.
     *
     * Returns: the polygons pointer
     */
    public static Polygons* create()
    {
        return cast(Polygons*) GC.calloc(Polygons.sizeof);
    }

    /**
     * Get a registered polygon.
     *
     * Params:
     *      name  =     the name
     */
    public Polygon get(const string name)
    {
        return this.polygons[name];
    }

    /**
     * Register a polygon.
     *
     * Params:
     *      name     =      the name
     *      polygon  =      the polygon
     */
    public void set(const string name, Polygon polygon)
    {
        this.polygons[name] = polygon;
    }

    /**
     * Clear the collection.
     */
    public void clear()
    {
        this.polygons.clear();
    }
}
