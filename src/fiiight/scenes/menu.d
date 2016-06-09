module fiiight.scenes.menu;

import common : Programs;
import engine : Textures, Texture, Polygons, Polygon, RenderState = State, TexturedMatrixPolygon, PolygonData;
import game : IScene;

import std.parallelism : TaskPool;

class MenuScene : IScene
{
    protected Polygon poly;
    protected PolygonData* polyData;

    /**
     * Loads the scene.
     *
     * Params:
     *      programs  =     the program collection
     *      textures  =     the texture collection
     *      polygons  =     the polygon collection
     */
    public void load(Programs* programs, Textures* textures, Polygons* polygons)
    {
        Texture texture = Texture("resources/textures/test.png");

        this.poly = new TexturedMatrixPolygon([
            0.25f, 0.25f,
            0.75f, 0.25f,
            0.75f, 0.75f,
            0.25f, 0.75f,
        ], [
            0.25f, 0.25f,
            0.75f, 0.25f,
            0.75f, 0.75f,
            0.25f, 0.75f,
        ], &texture);

        this.poly.load(programs);

        this.polyData = PolygonData.create();
    }

    /**
     * Unloads the scene.
     */
    public void unload()
    {
        // ...
    }

    /**
     * Update the scene.
     *
     * Params:
     *      tick      =     the tick amount
     *      taskPool  =     the available task pool
     */
    public void update(const float tick, TaskPool* taskPool)
    {
        // update ui
    }

    /**
     * Renders the scene.
     *
     * Params:
     *      renderState  =      the render state
     */
    public void render(RenderState* renderState)
    {
        renderState.render(this.poly, this.polyData);
    }
}
