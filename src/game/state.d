module game.state;

import engine : InputFactory;

import std.parallelism : TaskPool;

interface IState
{
    /**
     * Load the state.
     */
    void load(InputFactory* inputFactory);

    /**
     * Unload the state.
     */
    void unload();

    /**
     * Update the state.
     *
     * Params:
     *      tick      =     the tick amount
     *      taskPool  =     the available task pool
     */
    void update(const float tick, TaskPool* taskPool);

    /**
     * Render the state.
     */
    void render();
}
