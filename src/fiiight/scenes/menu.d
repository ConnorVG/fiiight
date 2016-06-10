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
    protected PolygonData[] data;
    protected uint selected = 0;

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

        for (int i = 0; i < 4; i++) {
            PolygonData _data = new PolygonData();

            if (i == this.selected) {
                _data.colour.r = 0.7f;
                _data.colour.g = 0.25f;
                _data.colour.b = 0.25f;
            }

            _data.position.x = 0.25f;
            _data.position.y = 0.2f * i + 0.2f;

            _data.scale.x = 0.25f;
            _data.scale.y = 0.1f;

            this.data ~= _data;
        }
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

        this.data[0].rotation += tick / 15f;
        this.data[1].rotation += tick / 30f;
        this.data[2].rotation += tick / 60f;
        this.data[3].rotation += tick / 120f;
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

        foreach (ref _data; this.data) {
            renderState.render(this.poly, _data);
        }
    }

    public void next()
    {
        this.data[this.selected].colour.r = 1.0f;
        this.data[this.selected].colour.g = 1.0f;
        this.data[this.selected].colour.b = 1.0f;

        this.selected = (this.selected + 1) % this.data.length;

        this.data[this.selected].colour.r = 0.7f;
        this.data[this.selected].colour.g = 0.25f;
        this.data[this.selected].colour.b = 0.25f;
    }
}
