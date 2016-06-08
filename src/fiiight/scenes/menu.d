module fiiight.scenes.menu;

import common : Programs;
import engine : Texture, Textures, MatrixPolygon, Polygon, Polygons, PolygonData, RenderState = State;
import game : IScene;

import std.parallelism : TaskPool, task;

class MenuScene : IScene
{
    protected Polygon triangle;
    protected PolygonData*[] data;

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
        Polygon triangle = new MatrixPolygon([
            -1.0f, -1.0f,
            1.0f, -1.0f,
            0.0f, 1.0f,
        ]);

        triangle.load(programs);

        this.triangle = triangle;
        polygons.set("triangle", triangle);

        this.data = [
            PolygonData.create(),
            PolygonData.create()
        ];
    }

    /**
     * Unloads the scene.
     */
    public void unload()
    { /** */ }

    /**
     * Update the scene.
     *
     * Params:
     *      tick      =     the tick amount
     *      taskPool  =     the available task pool
     */
    public void update(const float tick, TaskPool* taskPool)
    {
        void rotate(PolygonData* data, float rotation) {
            data.rotation.x += rotation;
        }

        taskPool.put(task(&rotate, this.data[0], tick / 360));
        taskPool.put(task(&rotate, this.data[1], -tick / 360));
    }

    /**
     * Renders the scene.
     *
     * Params:
     *      renderState  =      the render state
     */
    public void render(RenderState* renderState)
    {
        foreach (PolygonData* data; this.data) {
            renderState.render(this.triangle, data);
        }
    }
}
