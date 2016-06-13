module game.scene;

import game.state : StateCollections;
import engine : RenderState = State;

import std.parallelism : TaskPool;

interface IScene
{
    /**
     * Loads the scene.
     *
     * Params:
     *      collections  =      the state collections
     */
    void load(StateCollections* collections);

    /**
     * Unloads the scene.
     *
     * Params:
     *      collections  =      the state collections
     */
    void unload(StateCollections* collections);

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
