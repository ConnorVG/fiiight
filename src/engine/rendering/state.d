module engine.rendering.state;

import engine.rendering.camera : Camera;
import engine.rendering.polygon : Polygon, PolygonData;

import core.memory : GC;

struct State
{
    /**
     * The groups to render.
     */
    protected PolygonData[][Polygon] groups;

    /**
     * The width.
     *
     * Todo: make this actually real...
     */
    public ushort width;

    /**
     * The height.
     *
     * Todo: make this actually real...
     */
    public ushort height;

    /**
     * The width:height ratio.
     *
     * Todo: make this actually real...
     */
    public real ratio;

    /**
     * Creates an instance of state.
     *
     * Returns: a pointer to the state instance
     */
    public static State* create()
    {
        State* state = cast(State*) GC.calloc(State.sizeof);

        // Todo: read the properties
        state.width = 1080;
        state.height = 608;
        state.ratio = 1080. / 608.;

        return state;
    }

    /**
     * Render a polygon with X data.
     *
     * Params:
     *      polygon  =      the polygon
     *      data     =      the data
     */
    public void render(Polygon polygon, PolygonData data)
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
        foreach (Polygon polygon, PolygonData[] data; this.groups) {
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
