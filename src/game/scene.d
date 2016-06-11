module game.scene;

import common : Programs;
import engine : Textures, Polygons, RenderState = State, InputFactory;

import std.parallelism : TaskPool;

interface IScene
{
    /**
     * Loads the scene.
     *
     * Params:
     *      programs      =     the program collection
     *      textures      =     the texture collection
     *      polygons      =     the polygon collection
     *      inputFactory  =     the input factory
     */
    void load(Programs* programs, Textures* textures, Polygons* polygons, InputFactory* inputFactory);

    /**
     * Unloads the scene.
     *
     * Params:
     *      programs      =     the program collection
     *      textures      =     the texture collection
     *      polygons      =     the polygon collection
     *      inputFactory  =     the input factory
     */
    void unload(Programs* programs, Textures* textures, Polygons* polygons, InputFactory* inputFactory);

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
