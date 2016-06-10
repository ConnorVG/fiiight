module fiiight.scenes.menu;

import common : Programs;
import engine : Textures, Polygons, RenderState = State;
import engine : Shapes, Polygon, MatrixPolygon, TextMatrixPolygon, PolygonData, TextPolygonData;
import game : IScene, UI;

import std.parallelism : TaskPool;

class MenuScene : IScene
{
    /**
     * The current ui.
     */
    protected UI* ui;

    protected Polygon poly;
    protected PolygonData data;

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
        this.ui = UI.create();
        this.ui.load(programs, textures, polygons);

        this.poly = new MatrixPolygon(Shapes.RECTANGLE);

        this.poly.load(programs);

        this.data = new PolygonData();

        this.data.position.x = 0.5f;
        this.data.position.y = 0.5f;

        this.data.scale.x = 0.25f;
        this.data.scale.y = 0.5f;
    }

    /**
     * Unloads the scene.
     */
    public void unload()
    {
        this.ui.unload();
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
        this.ui.update(tick, taskPool);

        //this.data.rotation += tick / 60f;
    }

    /**
     * Renders the scene.
     *
     * Params:
     *      renderState  =      the render state
     */
    public void render(RenderState* renderState)
    {
        this.ui.render(renderState);

        renderState.render(this.poly, this.data);
    }
}
