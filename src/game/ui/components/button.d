module game.ui.components.button;

import game.ui.components.component : IComponent;
import common : Programs;
import engine : Textures, Polygons, RenderState = State;

import std.parallelism : TaskPool;

class ButtonComponent : IComponent
{
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
        textures.load("ui.button");
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
        // ...
    }

    /**
     * Renders the scene.
     *
     * Params:
     *      renderState  =      the render state
     */
    public void render(RenderState* renderState)
    {
        // ...
    }
}
