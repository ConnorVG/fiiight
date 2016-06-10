module game.ui.components.component;

import common : Programs;
import engine : Textures, Polygons, RenderState = State;

import std.parallelism : TaskPool;

interface IComponent
{
    /**
     * Loads the scene.
     *
     * Params:
     *      programs  =     the program collection
     *      textures  =     the texture collection
     *      polygons  =     the polygon collection
     */
    void load(Programs* programs, Textures* textures, Polygons* polygons);

    /**
     * Unloads the scene.
     */
    void unload();

    /**
     * Update the scene.
     *
     * Params:
     *      tick      =     the tick amount
     *      taskPool  =     the available task pool
     */
    void update(const float tick, TaskPool* taskPool);

    /**
     * Renders the scene.
     *
     * Params:
     *      renderState  =      the render state
     */
    void render(RenderState* renderState);
}
