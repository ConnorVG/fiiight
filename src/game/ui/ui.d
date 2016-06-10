module game.ui.ui;

import game.ui.components : IComponent;
import common : Programs;
import engine : Textures, Polygons, RenderState = State;

import std.parallelism : TaskPool;

import core.memory : GC;

struct UI
{
    /**
     * The ui components.
     */
    protected IComponent[] components;

    /**
     * We don't want the default construction to be possible.
     */
    @disable this();

    /**
     * Creates a collection of polygons.
     *
     * Returns: the polygons pointer
     */
    public static UI* create()
    {
        return cast(UI*) GC.calloc(UI.sizeof);
    }

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
        // ...
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
