module engine.rendering.state;

import engine.rendering.camera : Camera;
import engine.rendering.data : PolygonData;
import engine.rendering.polygon : Polygon;

import core.memory : GC;

struct State
{
    /**
     * The groups to render.
     */
    protected PolygonData*[][Polygon] groups;

    /**
     * Creates an instance of state.
     *
     * Returns: a pointer to the state instance
     */
    public static State* create()
    {
        return cast(State*) GC.calloc(State.sizeof);
    }

    /**
     * Render a polygon with X data.
     *
     * Params:
     *      polygon  =      the polygon
     *      data     =      the data
     */
    public void render(Polygon polygon, PolygonData* data)
    {
        this.groups[polygon] ~= data;
    }

    /**
     * Render the state.
     *
     * Params:
     *      camera  =       the camera
     */
    public void render(Camera* camera)
    {
        foreach (ref polygon, ref data; this.groups) {
            polygon.bind();
            polygon.render(camera, data);
            polygon.unbind();
        }
    }

    /**
     * Clear the rendering stack.
     */
    public void clear()
    {
        this.groups.clear();
    }
}
